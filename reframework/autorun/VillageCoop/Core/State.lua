local State = {
    version = "0.3.6",
    project_name = "Resident Evil Village Co-op",

    build = {
        codename = "Reflection Probe",
        stage = "Development",
        build_date = "2026-07-30",
    },

    ui = {
        window_open = true,
        f8_was_down = false,
        page = "Home",
        fatal_error = nil,
    },

    player = {
        nickname = "Wombo",
        available = false,
        health = 100,
        type_name = "Unknown",
        position = nil,
        rotation = nil,
        last_sample_clock = 0,
    },

    inspector = {
        status = "Ready",
        error = nil,
        player_type = "Unknown",
        component_count = 0,
        components = {},
        selected_index = 0,
        selected_type = "None",
        fields = {},
        methods = {},
        last_scan_clock = 0,
    },

    reflection = {
        status = "Ready",
        error = nil,
        type_name = "Unknown",
        namespace = "Unknown",
        parent_type = "None",
        field_count = 0,
        method_count = 0,
        fields = {},
        methods = {},
        last_probe_clock = 0,
    },

    console = {
        last_error = "None",
        last_native_call = "None",
        last_reflection = "None",
        last_component_scan = "Not run",
        reflection_api = "Compatibility layer loaded",
        json_status = "No active console error",
    },

    network = {
        status = "Offline",
        connected = false,
        hosting = false,
        address = "127.0.0.1",
        port = 7777,
        ping_ms = 0,
        tx_per_second = 0,
        rx_per_second = 0,
    },

    native = {
        plugin_loaded = false,
        report_available = false,
        pose_stream_available = false,
        remote_puppet_active = false,
        last_refresh_clock = 0,
    },

    runtime = {
        status = "Starting",
        frame_count = 0,
        start_clock = os.clock(),
        fps = 0,
        fps_timer = os.clock(),
        fps_frames = 0,
        last_action = "Core modules are loading.",
    },
}

return State
