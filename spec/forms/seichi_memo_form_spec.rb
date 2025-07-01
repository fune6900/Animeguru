require 'rails_helper'

RSpec.describe SeichiMemoForm, type: :model do
  let(:attributes) do
    {
      user_id: 1,
      title: "title",
      body: "body",
      anime_title: "anime title",
      anime_official_site_url: nil,
      place_name: "place name",
      place_address: nil,
      place_postal_code: nil,
      seichi_photo: nil,
      scene_image: nil,
      image_url: nil,
      genre_tag_ids: nil
    }
  end

  let(:valid_image) do
    fixture_file_upload(Rails.root.join("spec/fixtures/files/test.jpg"), "image/jpeg")
  end

  let(:invalid_image) do
    fixture_file_upload(Rails.root.join("spec/fixtures/files/test.txt"), "text/plain")
  end

  describe 'current_stepが未指定の場合' do
    it 'バリデーションがスキップされて有効になる' do
      form = SeichiMemoForm.new(attributes)
      expect(form).to be_valid
      expect(form.errors).to be_empty
    end
  end

  describe "バリデーションチェック: memoステップ" do
    before { attributes[:current_step] = "memo" }

    it "titleが空なら無効" do
      form = SeichiMemoForm.new(attributes.merge(title: ""))
      expect(form).to be_invalid
      expect(form.errors[:title]).to include("を入力してください")
    end

    it "titleが31文字以上なら無効" do
      form = SeichiMemoForm.new(attributes.merge(title: "a" * 31))
      expect(form).to be_invalid
      expect(form.errors[:title]).to include("は30文字以内で入力してください")
    end

    it "bodyが空なら無効" do
      form = SeichiMemoForm.new(attributes.merge(body: ""))
      expect(form).to be_invalid
      expect(form.errors[:body]).to include("を入力してください")
    end

    it "bodyが501文字以上なら無効" do
      form = SeichiMemoForm.new(attributes.merge(body: "a" * 501))
      expect(form).to be_invalid
      expect(form.errors[:body]).to include("は500文字以内で入力してください")
    end

    it "seichi_photoが不正な拡張子なら無効" do
      form = SeichiMemoForm.new(attributes.merge(seichi_photo: invalid_image))
      expect(form).to be_invalid
      expect(form.errors[:seichi_photo]).to include("は jpg, jpeg, png, gif, webpのいずれかの形式でアップロードしてください")
    end

    it "seichi_photoが有効な拡張子なら有効" do
      form = SeichiMemoForm.new(attributes.merge(seichi_photo: valid_image))
      expect(form).to be_valid
      expect(form.errors).to be_empty
    end

    it "seichi_photoが未指定でも有効" do
      form = SeichiMemoForm.new(attributes.merge(seichi_photo: nil))
      expect(form).to be_valid
      expect(form.errors).to be_empty
    end

    it "scene_imageが不正な拡張子なら無効" do
      form = SeichiMemoForm.new(attributes.merge(scene_image: invalid_image))
      expect(form).to be_invalid
      expect(form.errors[:scene_image]).to include("は jpg, jpeg, png, gif, webpのいずれかの形式でアップロードしてください")
    end

    it "scene_imageが有効な拡張子なら有効" do
      form = SeichiMemoForm.new(attributes.merge(scene_image: valid_image))
      expect(form).to be_valid
      expect(form.errors).to be_empty
    end

    it "scene_imageが未指定でも有効" do
      form = SeichiMemoForm.new(attributes.merge(scene_image: nil))
      expect(form).to be_valid
      expect(form.errors).to be_empty
    end
  end

  describe "バリデーションチェック: animeステップ" do
    before { attributes[:current_step] = "anime" }

    it "anime_titleが空なら無効" do
      form = SeichiMemoForm.new(attributes.merge(anime_title: ""))
      expect(form).to be_invalid
      expect(form.errors[:anime_title]).to include("を入力してください")
    end

    it "anime_titleが101文字以上なら無効" do
      form = SeichiMemoForm.new(attributes.merge(anime_title: "a" * 101))
      expect(form).to be_invalid
      expect(form.errors[:anime_title]).to include("は100文字以内で入力してください")
    end

    it "anime_official_site_urlが不正なURL形式なら無効" do
      form = SeichiMemoForm.new(attributes.merge(anime_official_site_url: "not_a_url"))
      expect(form).to be_invalid
      expect(form.errors[:anime_official_site_url]).to include("は正しいURL形式で入力してください")
    end

    it "anime_official_site_urlが空でも有効" do
      form = SeichiMemoForm.new(attributes.merge(anime_official_site_url: nil))
      expect(form).to be_valid
      expect(form.errors).to be_empty
    end

    it "image_urlが不正な拡張子なら無効" do
      form = SeichiMemoForm.new(attributes.merge(image_url: invalid_image))
      expect(form).to be_invalid
      expect(form.errors[:image_url]).to include("は jpg, jpeg, png, gif, webpのいずれかの形式でアップロードしてください")
    end

    it "image_urlが有効な拡張子なら有効" do
      form = SeichiMemoForm.new(attributes.merge(image_url: valid_image))
      expect(form).to be_valid
      expect(form.errors).to be_empty
    end

    it "image_urlが未指定でも有効" do
      form = SeichiMemoForm.new(attributes.merge(image_url: nil))
      expect(form).to be_valid
      expect(form.errors).to be_empty
    end

    it "genre_tag_idsが空でも有効" do
      form = SeichiMemoForm.new(attributes.merge(genre_tag_ids: nil))
      expect(form).to be_valid
      expect(form.errors).to be_empty
    end

    it "genre_tag_ids が0〜3個以内なら有効" do
      form = SeichiMemoForm.new(attributes.merge(genre_tag_ids: [1, 2, 3]))
      expect(form).to be_valid
      expect(form.errors).to be_empty
    end

    it "genre_tag_ids が4個以上なら無効" do
      form = SeichiMemoForm.new(attributes.merge(genre_tag_ids: [1, 2, 3, 4]))
      expect(form).to be_invalid
      expect(form.errors[:genre_tag_ids]).to include("は3つまでしか選択できません")
    end
  end

  describe "バリデーションチェック: placeステップ" do
    before { attributes[:current_step] = "place" }

    it "place_nameが空なら無効" do
      form = SeichiMemoForm.new(attributes.merge(place_name: ""))
      expect(form).to be_invalid
      expect(form.errors[:place_name]).to include("を入力してください")
    end

    it "place_nameが101文字以上なら無効" do
      form = SeichiMemoForm.new(attributes.merge(place_name: "a" * 101))
      expect(form).to be_invalid
      expect(form.errors[:place_name]).to include("は100文字以内で入力してください")
    end

    it "place_addressが201文字以上なら無効" do
      form = SeichiMemoForm.new(attributes.merge(place_address: "a" * 201))
      expect(form).to be_invalid
      expect(form.errors[:place_address]).to include("は200文字以内で入力してください")
    end

    it "place_addressが空でも有効" do
      form = SeichiMemoForm.new(attributes.merge(place_address: nil))
      expect(form).to be_valid
      expect(form.errors).to be_empty
    end

    it "place_postal_codeがXXX-XXXX形式なら有効" do
      form = SeichiMemoForm.new(attributes.merge(place_postal_code: "123-4567"))
      expect(form).to be_valid
      expect(form.errors).to be_empty
    end

    it "place_postal_codeがXXX-XXXX形式でないと無効" do
      form = SeichiMemoForm.new(attributes.merge(place_postal_code: "1234567"))
      expect(form).to be_invalid
      expect(form.errors[:place_postal_code]).to include("はXXX-XXXXの形式で入力してください")
    end

    it "place_postal_codeが空でも有効" do
      form = SeichiMemoForm.new(attributes.merge(place_postal_code: nil))
      expect(form).to be_valid
      expect(form.errors).to be_empty
    end
  end
end
