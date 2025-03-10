class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.436",
      revision: "61353088f125dfb9341502f91876496d10bc4eb8"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b95cd19db346f0d5e2d1f6083a189077d4ed4631dd42505ed49b0b2294032818"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b95cd19db346f0d5e2d1f6083a189077d4ed4631dd42505ed49b0b2294032818"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b95cd19db346f0d5e2d1f6083a189077d4ed4631dd42505ed49b0b2294032818"
    sha256 cellar: :any_skip_relocation, ventura:        "d2d716595313ab91e716095e3aad53078aa333fb4decad86ec2c49fddc2298c1"
    sha256 cellar: :any_skip_relocation, monterey:       "d2d716595313ab91e716095e3aad53078aa333fb4decad86ec2c49fddc2298c1"
    sha256 cellar: :any_skip_relocation, big_sur:        "d2d716595313ab91e716095e3aad53078aa333fb4decad86ec2c49fddc2298c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "544ae913672887537a5476886a263792434aabd693a4ee7a570883d3b13b19bd"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/superfly/flyctl/internal/buildinfo.environment=production
      -X github.com/superfly/flyctl/internal/buildinfo.buildDate=#{time.iso8601}
      -X github.com/superfly/flyctl/internal/buildinfo.version=#{version}
      -X github.com/superfly/flyctl/internal/buildinfo.commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin/"flyctl", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("flyctl status 2>&1", 1)
    assert_match "Error No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
