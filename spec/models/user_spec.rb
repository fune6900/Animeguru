require 'rails_helper'

RSpec.describe User, type: :model do
  describe "バリデーションチェック" do
    it "ユーザー名、メールアドレス、パスワードがあれば有効であること" do
      user = build(:user)
      expect(user).to be_valid
      expect(user.errors).to be_empty
    end

    it "ユーザー名、メールアドレス、パスワードは必須項目であること" do
      user = build(:user, username: nil, email: nil, password: nil)
      expect(user).to be_invalid
      expect(user.errors[:username]).to include("を入力してください")
      expect(user.errors[:email]).to include("を入力してください")
      expect(user.errors[:password]).to include("を入力してください")
    end

    it "ユーザー名は2文字以上であること" do
      user = build(:user, username: "a")
      expect(user).to be_invalid
      expect(user.errors[:username]).to include("は2文字以上で入力してください")
    end

        it "ユーザー名が25文字以上であれば無効であること" do
      user = build(:user, username: "a" * 26)
      expect(user).to be_invalid
      expect(user.errors[:username]).to include("は25文字以内で入力してください")
    end

    it "ユーザー名が2文字以上25文字以内であれば有効であること" do
      user = build(:user, username: "a" * 2)
      expect(user).to be_valid
      expect(user.errors).to be_empty
    end

    it "同じユーザー名が既に存在する場合は無効であること" do
      user1 = create(:user)
      user2 = build(:user, username: user1.username)
      expect(user2).to be_invalid
      expect(user2.errors[:username]).to include("は既に使用されています")
    end

    it "パスワードは6文字以上であれば有効であること" do
      user = build(:user, password: "123456")
      expect(user).to be_valid
      expect(user.errors).to be_empty
    end

    it "パスワードは6文字以上であること" do
      user = build(:user, password: "12345")
      expect(user).to be_invalid
      expect(user.errors[:password]).to include("は6文字以上で入力してください")
    end

    it "重複したメールアドレスの場合無効であること" do
      user1 = create(:user)
      user2 = build(:user, email: user1.email)
      expect(user2).to be_invalid
      expect(user2.errors[:email]).to include("は既に使用されています")
    end

    it "自己紹介文(ひとこと)が500文字以内であれば有効であること" do
      user = build(:user, introduction: "a" * 500)
      expect(user).to be_valid
      expect(user.errors).to be_empty
    end

    it "自己紹介文(ひとこと)が500文字以上であれば有無効であること" do
      user = build(:user, introduction: "a" * 501)
      expect(user).to be_invalid
      expect(user.errors[:introduction]).to include("は500文字以内で入力してください")
    end

    it "自己紹介が空でも有効であること" do
      user = build(:user, introduction: nil)
      expect(user).to be_valid
      expect(user.errors).to be_empty
    end

    it "プロフィール画像がjpg, jpeg, png, gif, webp形式であれば有効であること" do
      user = build(:user, profile_image: fixture_file_upload("test.jpg", "image/jpeg"))
      expect(user).to be_valid
      expect(user.errors).to be_empty
    end

    it "プロフィール画像がjpg, jpeg, png, gif, webp形式でなければ無効であること" do
      user = build(:user, profile_image: fixture_file_upload("test.txt", "text/plain"))
      expect(user).to be_invalid
      expect(user.errors[:profile_image]).to include("はjpg, jpeg, png, gif, webpのいずれかの形式でアップロードしてください")
    end

    it "プロフィール画像がアップロードされていない場合でも有効であること" do
      user = build(:user, profile_image: nil)
      expect(user).to be_valid
      expect(user.errors).to be_empty
    end

    it "お気に入りのアニメ作品が50文字以内であれば有効であること" do
      user = build(:user, favorite_anime: "a" * 50)
      expect(user).to be_valid
      expect(user.errors).to be_empty
    end

    it "お気に入りのアニメ作品が50文字以上であれば無効であること" do
      user = build(:user, favorite_anime: "a" * 51)
      expect(user).to be_invalid
      expect(user.errors[:favorite_anime]).to include("は50文字以内で入力してください")
    end

    it "お気に入りのアニメ作品が空でも有効であること" do
      user = build(:user, favorite_anime: nil)
      expect(user).to be_valid
      expect(user.errors).to be_empty
    end

    it "パスワードとパスワード確認が一致すれば有効であること" do
      user = build(:user, password_confirmation: "password")
      expect(user).to be_valid
      expect(user.errors).to be_empty
    end

    it "パスワードとパスワード確認が一致しなければ無効であること" do
      user = build(:user, password_confirmation: "different_password")
      expect(user).to be_invalid
      expect(user.errors[:password_confirmation]).to include("とパスワードの入力が一致しません")
    end
  end
end
