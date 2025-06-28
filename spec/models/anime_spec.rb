require 'rails_helper'

RSpec.describe Anime, type: :model do
  describe "バリデーションチェック" do
    it "設定したすべてのバリデーションが機能しているか" do
      anime = build(:anime)
      expect(anime).to be_valid
      expect(anime.errors).to be_empty
    end

    it "空だと無効になる" do
      anime = build(:anime, title: "")
      expect(anime).to be_invalid
      expect(anime.errors[:title]).to include("を入力してください")
    end

    it "101文字以上だと無効になる" do
      anime = build(:anime, title: "a" * 101)
      expect(anime).to be_invalid
      expect(anime.errors[:title]).to include("は100文字以内で入力してください")
    end

    it "重複したタイトルは無効になる" do
      anime1 = create(:anime)
      anime2 = build(:anime, title: "title")
      expect(anime2).to be_invalid
      expect(anime2.errors[:title]).to include("はすでに存在します")
    end

    it "URL形式でないと無効になる" do
      anime = build(:anime, official_site_url: "not_a_url")
      expect(anime).to be_invalid
      expect(anime.errors[:official_site_url]).to include("は正しいURL形式で入力してください")
    end

    it "空欄でも有効である" do
      anime = build(:anime, official_site_url: "")
      expect(anime).to be_valid
      expect(anime.errors).to be_empty
    end
  end
end
