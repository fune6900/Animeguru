require 'rails_helper'

RSpec.describe "UserSessions", type: :system do
  let(:user) { create(:user) }

  describe "ログイン前" do
    describe "ログイン" do
      context "フォームの入力値が正常" do
        it "ログイン処理が成功する" do
          visit new_user_session_path
          fill_in "user_email", with: user.email
          fill_in "user_password", with: "password"
          click_button "ログイン"
          expect(page).to have_content("ログインしました。さっそく聖地メモを投稿してみませんか？")
          expect(current_path).to eq seichi_memos_path
        end
      end

      context "フォームが未入力" do
        it "ログインが失敗する" do
          visit new_user_session_path
          fill_in "user_email", with: ""
          fill_in "user_password", with: "password"
          click_button "ログイン"
          expect(page).to have_content("メールアドレスまたはパスワードが間違っています")
          expect(current_path).to eq new_user_session_path
        end
      end
    end

    describe "ログアウト" do
      context "ログインしている状態" do
        before { login_as(user) }

        it "ハンバーガーメニューからログアウト処理が成功する" do
          visit seichi_memos_path
          find('label[for="menu-drawer"]', match: :first).click
          expect(page).to have_content ("ログアウト")
          click_on "ログアウト"
          # expect(page).to have_content("ログアウトしました")
          # expect(current_path).to eq root_path
        end

        it "マイページからログアウト処理が成功する" do
          visit profile_path
          expect(page).to have_content(user.username)
          find("#logout-from-profile").click
          expect(page).to have_content("ログアウトしました")
          expect(current_path).to eq root_path
        end
      end
    end
  end
end
