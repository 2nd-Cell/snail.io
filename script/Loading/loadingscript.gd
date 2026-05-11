extends CanvasLayer

# ============================================================
#  LoadingScreen.gd
#  Attach to: LoadingScreen.tscn (a CanvasLayer scene)
#  Add as AutoLoad in Project > Project Settings > AutoLoad
#  AutoLoad name: LoadingScreen
# ============================================================
#
#  USAGE — from any scene:
#
#      LoadingScreen.change_scene("res://scenes/GameWorld.tscn")
#
#  Optional: pass metadata to the destination scene:
#
#      LoadingScreen.change_scene("res://scenes/GameWorld.tscn", {
#          "player_spawn": Vector2(200, 300),
#          "level": 2
#      })
#      # In the destination scene's _ready():
#      #   var meta = LoadingScreen.get_transfer_data()
#
# ============================================================

signal loading_started(destination: String)
signal loading_finished(destination: String)
signal loading_progress_changed(progress: float)

# ── Node references (set in _ready, matched by node name) ───
@onready var _overlay:        Control     = $Overlay
@onready var _bar:            ProgressBar = $Overlay/VBox/ProgressBar
@onready var _percent_label:  Label       = $Overlay/VBox/PercentLabel
@onready var _status_label:   Label       = $Overlay/VBox/StatusLabel
@onready var _scene_name_label: Label     = $Overlay/VBox/SceneNameLabel
@onready var _anim:           AnimationPlayer = $AnimationPlayer

# ── Internal state ──────────────────────────────────────────
var _loading_path:   String  = ""
var _transfer_data:  Dictionary = {}
var _loader:         int
var _load_request:   String  = ""
var _is_loading:     bool    = false
var _fake_progress:  float   = 0.0  # smoothed display value

# Tweakable constants
const FAKE_FILL_SPEED:  float = 0.35   # max extra progress added per second while waiting
const PROGRESS_LERP:    float = 8.0    # smoothing speed for the bar
const MIN_DISPLAY_TIME: float = 0.6    # minimum seconds the screen stays visible


func _ready() -> void:
	layer = 128  # render above everything
	_overlay.visible = false
	set_process(false)


# ── Public API ───────────────────────────────────────────────

## Call this from any scene to trigger a scene transition.
func change_scene(destination_path: String, transfer_data: Dictionary = {}) -> void:
	if _is_loading:
		push_warning("LoadingScreen: already loading, ignoring request for %s" % destination_path)
		return

	_loading_path  = destination_path
	_transfer_data = transfer_data
	_start_loading()


## Retrieve metadata that was passed with change_scene().
## Call this from the destination scene's _ready().
func get_transfer_data() -> Dictionary:
	return _transfer_data


# ── Internal: setup ──────────────────────────────────────────

func _start_loading() -> void:
	_is_loading    = true
	_fake_progress = 0.0

	# Show the loading UI
	_overlay.visible = true
	_scene_name_label.text = _loading_path.get_file().get_basename()
	_set_progress(0.0)
	_set_status("Initialising…")

	if _anim and _anim.has_animation("fade_in"):
		_anim.play("fade_in")

	emit_signal("loading_started", _loading_path)

	# Begin threaded background load
	var err: Error = ResourceLoader.load_threaded_request(_loading_path)
	if err != OK:
		_set_status("Error: could not start loading '%s' (code %d)" % [_loading_path, err])
		push_error("LoadingScreen: load_threaded_request failed for %s" % _loading_path)
		_is_loading = false
		return

	set_process(true)


# ── Internal: per-frame poll ─────────────────────────────────

var _elapsed: float = 0.0

func _process(delta: float) -> void:
	_elapsed += delta

	var progress_array: Array = []
	var status: int = ResourceLoader.load_threaded_get_status(
		_loading_path, progress_array
	)

	match status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			var real_progress: float = progress_array[0] if not progress_array.is_empty() else 0.0
			# Fake-fill up to 90 % while waiting; real progress can push past
			var fake_ceil: float = min(real_progress + 0.15, 0.90)
			_fake_progress = min(_fake_progress + FAKE_FILL_SPEED * delta, fake_ceil)
			_fake_progress = max(_fake_progress, real_progress)
			_smooth_set_progress(_fake_progress, delta)
			_set_status("Loading assets…")

		ResourceLoader.THREAD_LOAD_LOADED:
			_smooth_set_progress(1.0, delta)
			_set_status("Ready!")
			# Ensure minimum display time so the player can read the screen
			if _elapsed >= MIN_DISPLAY_TIME:
				_finish_loading()

		ResourceLoader.THREAD_LOAD_FAILED, ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			_set_status("Failed to load scene!")
			push_error("LoadingScreen: failed to load '%s'" % _loading_path)
			set_process(false)
			_is_loading = false


func _finish_loading() -> void:
	set_process(false)
	_elapsed = 0.0

	var resource = ResourceLoader.load_threaded_get(_loading_path)
	if resource == null or not resource is PackedScene:
		push_error("LoadingScreen: loaded resource is not a PackedScene — %s" % _loading_path)
		_is_loading = false
		return

	emit_signal("loading_finished", _loading_path)

	if _anim and _anim.has_animation("fade_out"):
		_anim.play("fade_out")
		await _anim.animation_finished

	# Swap the scene; our CanvasLayer persists because it is an AutoLoad
	get_tree().change_scene_to_packed(resource)

	# Hide UI after the new scene is up
	await get_tree().process_frame
	_overlay.visible = false
	_is_loading = false


# ── Helpers ──────────────────────────────────────────────────

func _smooth_set_progress(target: float, delta: float) -> void:
	var current: float = _bar.value / 100.0
	var smoothed: float = lerp(current, target, clamp(PROGRESS_LERP * delta, 0.0, 1.0))
	_set_progress(smoothed)


func _set_progress(value: float) -> void:
	# value is 0.0 – 1.0
	value = clamp(value, 0.0, 1.0)
	_bar.value = value * 100.0
	_percent_label.text = "%d %%" % int(value * 100.0)
	emit_signal("loading_progress_changed", value)


func _set_status(text: String) -> void:
	_status_label.text = text
