require 'rails_helper'

RSpec.describe Place, type: :model do
  describe "バリデーションチェック" do
    it "設定したすべてのバリデーションが機能しているか" do
      place = build(:place)
      expect(place).to be_valid
      expect(place.errors).to be_empty
    end

    it "nameが空だと無効になる" do
      place = build(:place, name: "")
      expect(place).to be_invalid
      expect(place.errors[:name]).to include("を入力してください")
    end

    it "nameが101文字以上だと無効になる" do
      place = build(:place, name: "あ" * 101)
      expect(place).to be_invalid
      expect(place.errors[:name]).to include("は100文字以内で入力してください")
    end

    it "nameが重複していると無効になる" do
      place1 = create(:place, name: "秋葉原")
      place2 = build(:place, name: "秋葉原")
      expect(place2).to be_invalid
      expect(place2.errors[:name]).to include("はすでに存在します")
    end

    it "addressが201文字以上だと無効になる" do
      place = build(:place, address: "a" * 201)
      expect(place).to be_invalid
      expect(place.errors[:address]).to include("は200文字以内で入力してください")
    end

    it "addressが空でも有効である" do
      place = build(:place, address: "")
      expect(place).to be_valid
      expect(place.errors).to be_empty
    end

    it "postal_codeがXXX-XXXX形式でないと無効になる" do
      place = build(:place, postal_code: "1234567")
      expect(place).to be_invalid
      expect(place.errors[:postal_code]).to include("はXXX-XXXXの形式で入力してください")
    end

    it "postal_codeが空でも有効である" do
      place = build(:place, postal_code: "")
      expect(place).to be_valid
      expect(place.errors).to be_empty
    end
  end
end
