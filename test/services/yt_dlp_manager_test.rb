require "test_helper"

class YtDlpManagerTest < ActiveSupport::TestCase
  test "ensure_binary_exists downloads the binary if it does not exist" do
    YtDlpManager.expects(:download_binary)
    File.expects(:exist?).with(YtDlpManager::BINARY_PATH).returns(false)
    YtDlpManager.ensure_binary_exists
  end

  test "ensure_binary_exists does not download the binary if it exists" do
    YtDlpManager.expects(:download_binary).never
    File.expects(:exist?).with(YtDlpManager::BINARY_PATH).returns(true)
    YtDlpManager.ensure_binary_exists
  end

  test "download binary downloads the binary" do
    FileUtils.expects(:mkdir_p).with(File.dirname(YtDlpManager::BINARY_PATH))
    URI.expects(:open).with(YtDlpManager::BINARY_URL).returns(stub(read: "binary"))
    File.expects(:binwrite).with(YtDlpManager::BINARY_PATH, "binary")
    FileUtils.expects(:chmod).with(0o755, YtDlpManager::BINARY_PATH)
    YtDlpManager.download_binary
  end

  test "update_binary updates the binary if it exists" do
    File.expects(:exist?).with(YtDlpManager::BINARY_PATH).returns(true)
    YtDlpManager.expects(:`).with("#{YtDlpManager::BINARY_PATH} --update-to nightly 2>&1").returns("output")
    assert_equal({success: true, message: "output"}, YtDlpManager.update_binary)
  end

  test "update_binary downloads the binary if it does not exist" do
    File.expects(:exist?).with(YtDlpManager::BINARY_PATH).returns(false)
    YtDlpManager.expects(:download_binary)
    assert_equal({success: true, message: "Downloaded fresh copy of yt-dlp"}, YtDlpManager.update_binary)
  end

  test "version returns the version of the binary" do
    File.expects(:exist?).with(YtDlpManager::BINARY_PATH).returns(true)
    YtDlpManager.expects(:`).with("#{YtDlpManager::BINARY_PATH} --version 2>&1").returns("version")
    assert_equal "version", YtDlpManager.version
  end
end
