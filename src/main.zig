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
    const title = "LearnOpenGL";
    var window: WindowPtr = undefined;

    if (c_api.glfwInit() != c_api.GLFW_TRUE) {
        print("Failed to initialilze glfw library.\n", .{});
        return;
    }
    defer c_api.glfwTerminate();

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

    while (c_api.glfwWindowShouldClose(window) != c_api.GLFW_TRUE) {
        c_api.glClear(c_api.GL_COLOR_BUFFER_BIT);

        c_api.glfwSwapBuffers(window);

        c_api.glfwPollEvents();
    }
}
