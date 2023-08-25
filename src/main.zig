const std = @import("std");
const print = std.debug.print;

const c_api = @cImport({
    @cDefine("GLFW_INCLUDE_NONE", "");
    @cInclude("GLFW/glfw3.h");
    @cInclude("glad/gl.h");
});

const WindowPtr = *c_api.GLFWwindow;

pub fn main() void {
    const width = 800;
    const height = 600;
    const title = "LearningOpenGL";
    var window: WindowPtr = undefined;

    _ = c_api.glfwSetErrorCallback(error_callback);
    defer {
        _ = c_api.glfwSetErrorCallback(null);
    }

    if (c_api.glfwInit() != c_api.GLFW_TRUE) {
        print("Failed to initialilze glfw library.\n", .{});
        return;
    }
    defer c_api.glfwTerminate();

    c_api.glfwWindowHint(c_api.GLFW_CONTEXT_VERSION_MAJOR, 3);
    c_api.glfwWindowHint(c_api.GLFW_CONTEXT_VERSION_MINOR, 3);
    c_api.glfwWindowHint(c_api.GLFW_OPENGL_PROFILE, c_api.GLFW_OPENGL_CORE_PROFILE);

    window = c_api.glfwCreateWindow(width, height, title, null, null) orelse {
        print("Failed to create window.\n", .{});
        return;
    };
    defer c_api.glfwDestroyWindow(window);

    c_api.glfwMakeContextCurrent(window);

    if (c_api.gladLoadGL(c_api.glfwGetProcAddress) == 1) {
        print("Failed to load opengl bindings.\n", .{});
        return;
    }

    c_api.glViewport(0, 0, width, height);
    c_api.glClearColor(0.2, 0.3, 0.3, 1.0);

    // set callbacks
    _ = c_api.glfwSetFramebufferSizeCallback(window, framebuffer_size_callback);

    while (c_api.glfwWindowShouldClose(window) != c_api.GLFW_TRUE) {
        c_api.glClear(c_api.GL_COLOR_BUFFER_BIT);
        c_api.glfwSwapBuffers(window);

        c_api.glfwPollEvents();

        if (c_api.glfwGetKey(window, c_api.GLFW_KEY_SPACE) == c_api.GLFW_PRESS) {
            print("closing window\n", .{});
            c_api.glfwSetWindowShouldClose(window, c_api.GLFW_TRUE);
        }
    }
}

fn error_callback(code: c_int, msg: [*c]const u8) callconv(.C) void {
    _ = code;
    print("glfw error: {s}\n", .{msg});
}

fn framebuffer_size_callback(window: ?WindowPtr, width: c_int, height: c_int) callconv(.C) void {
    _ = window;
    c_api.glViewport(0, 0, width, height);
}
