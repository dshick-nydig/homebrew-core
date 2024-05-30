class Mactop < Formula
  desc "Apple Silicon Monitor Top written in Golang"
  homepage "https://github.com/context-labs/mactop"
  url "https://github.com/context-labs/mactop/archive/refs/tags/v0.1.8.tar.gz"
  sha256 "18a44c34a0915141ce4a628ef061c82b24eb25c7fb44ee761a332fd39cb688a0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f954130993d476e14279ca7e6742892fc9f57172cfcb3a05e36b0c7a7b6df37e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5407358518946c9c69428328c060dd994721b5021bfba5c8488f4fee07530bb6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb626cee7a0b7101b3aab9fd380c2a95d3509001cd06385e6567a6ca1c8f1f1d"
  end

  depends_on "go" => :build
  depends_on arch: :arm64
  depends_on :macos

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  def caveats
    <<~EOS
      mactop requires root privileges, so you will need to run `sudo mactop`.
      You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    test_input = "This is a test input for brew"
    assert_match "Test input received: #{test_input}", shell_output("#{bin}/mactop --test '#{test_input}'")
  end
end
