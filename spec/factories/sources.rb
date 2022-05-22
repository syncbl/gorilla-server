FactoryBot.define do
  factory :source1, class: "Source" do
    version { "1.0" }
    caption { "Test1" }
    description { "Test 1" }
    files do
      { "Qt5Gui.dll" => "1kWODzxFBoqNiHLDf7rY7g==",
        "quazip.dll" => "YTOKdyo2BDcvmw3aG68rVQ==",
        "PocoNet.dll" => "dhQ1dt5BSGi10a4HrAcWFQ==",
        "PocoXml.dll" => "ZXfcEvUPZtp/ApNNj+6HGw==",
        "PocoZip.dll" => "r2Wm1tf4Y9eocvRsAzhy4A==",
        "Qt5Core.dll" => "cLyLtAV5MlqQZ75iffNQ6Q==",
        "PocoData.dll" => "Li4Cj5+cmyeEepU1XFoTng==",
        "PocoJSON.dll" => "yYVWihOflvFnAg8OpZNr2g==",
        "PocoUtil.dll" => "blu/2CrUvDQmuitMiKtozQ==",
        "PocoCrypto.dll" => "B/MigPQR3Mrsi3DXzl+JSw==",
        "PocoNetSSL.dll" => "wmoi1fnZimdDXFMC9KK37Q==",
        "Qt5Network.dll" => "DsP+Nn+uJ9B30v52IrPbzA==",
        "Qt5Widgets.dll" => "gmwT2+ANDvLll/lAYiQkZQ==",
        "PocoDataSQLite.dll" => "/jpU7lv70PL/p3zOsfT3XQ==",
        "PocoFoundation.dll" => "5NRx/aaGCXDN4At5p7IcFw==",
        "LicenseSigner/LicenseSigner.suo" => "5Gth/rlXuhLAtMt17jBeCA==" }
end
    file do
      Rack::Test::UploadedFile.new(
        File.open(Rails.root.join("files/test1.zip")),
      )
    end
  end
end
