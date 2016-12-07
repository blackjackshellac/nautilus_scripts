require 'nautilus_scripts'

describe Nautilus::Scripts do
	describe ".defile" do
		context "return path without file uri and spaces" do
			before do
				@@files=%W(file:///abc\ foo file:///def\ bar)
			end
			it "defiles a file uri" do
				expect(Nautilus::Scripts.defile(@@files[0])).to eq("/abc foo")
			end
		end
	end

	describe ".selected_uris" do
		context "given no argument" do
			it "returns empty array" do
				expect(Nautilus::Scripts.selected_uris).to be_empty
			end
		end

		context "given an empty string" do
			it "returns empty array" do
				expect(Nautilus::Scripts.selected_uris("")).to be_empty
			end
		end

		context "given no argument" do
			before do
				#NAUTILUS_SCRIPT_SELECTED_URIS='file:///home/tmp/bjs/nexus_5/links/20161202/Internal%20shared%20storage/DCIM/Camera/IMG_20131122_111539.jpg
				ENV['NAUTILUS_SCRIPT_SELECTED_URIS']="file:///home/tmp/abc\nfile:///home/tmp/def"
			end
			it "returns an array with two uris" do
				expect(Nautilus::Scripts.selected_uris.length).to be(2)
			end
		end
	end
end

