class Glaze < Formula
  desc "Extremely fast, in-memory JSON and interface library for modern C++"
  homepage "https://github.com/stephenberry/glaze"
  url "https://github.com/stephenberry/glaze/archive/refs/tags/v4.2.2.tar.gz"
  sha256 "965e32de67e60d185402e8cfe684c6d40c1f018a4fa5e781b11b0cac0817edb9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f739a21f9a4a9a30229756d9640a6492205abea1954eb9756ea8da00d6e3029"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f739a21f9a4a9a30229756d9640a6492205abea1954eb9756ea8da00d6e3029"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2f739a21f9a4a9a30229756d9640a6492205abea1954eb9756ea8da00d6e3029"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f739a21f9a4a9a30229756d9640a6492205abea1954eb9756ea8da00d6e3029"
    sha256 cellar: :any_skip_relocation, ventura:       "2f739a21f9a4a9a30229756d9640a6492205abea1954eb9756ea8da00d6e3029"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bc4e57b79a9eb0f358aa94afbc18c0cb4d21d0c417a4dcc4633764be8db19c5"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "llvm" => :test

  def install
    args = %w[
      -Dglaze_DEVELOPER_MODE=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    ENV["CXX"] = Formula["llvm"].opt_bin/"clang++"
    # Issue ref: https://github.com/stephenberry/glaze/issues/1500
    ENV.append_to_cflags "-stdlib=libc++" if OS.linux?

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.16)
      project(GlazeTest LANGUAGES CXX)

      set(CMAKE_CXX_STANDARD 20)
      set(CMAKE_CXX_STANDARD_REQUIRED ON)

      find_package(glaze REQUIRED)

      add_executable(glaze_test test.cpp)
      target_link_libraries(glaze_test PRIVATE glaze::glaze)
    CMAKE

    (testpath/"test.cpp").write <<~CPP
      #include <glaze/glaze.hpp>
      #include <map>
      #include <string_view>

      int main() {
        const std::string_view json = R"({"key": "value"})";
        std::map<std::string, std::string> data;
        auto result = glz::read_json(data, json);
        return (!result && data["key"] == "value") ? 0 : 1;
      }
    CPP

    system "cmake", "-S", ".", "-B", "build", "-Dglaze_DIR=#{share}/glaze"
    system "cmake", "--build", "build"
    system "./build/glaze_test"
  end
end
