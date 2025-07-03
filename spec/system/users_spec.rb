require 'rails_helper'

RSpec.describe "Users", type: :system do
  include LoginMacros
  let!(:user) { create(:user) }

  describe "ログイン前" do
    describe "ユーザー新規登録" do
      context "フォームの入力値が正常" do
        it "ユーザー作成が成功する" do
          visit new_user_registration_path
          fill_in "user_username", with: "テストユーザー"
          fill_in "user_email", with: "animeguru@example.com"
          fill_in "user_password", with: "password"
          fill_in "user_password_confirmation", with: "password"
          click_button "アカウント登録"
          expect(page).to have_content("アカウント登録が完了しました。さっそく聖地メモを投稿してみませんか？")
          expect(current_path).to eq seichi_memos_path
        end
      end

      context "メールアドレスが未入力" do
        it "ユーザー作成が失敗する" do
          visit new_user_registration_path
          fill_in "user_username", with: "テストユーザー"
          fill_in "user_email", with: ""
          fill_in "user_password", with: "password"
          fill_in "user_password_confirmation", with: "password"
          click_button "アカウント登録"
          expect(page).to have_content("メールアドレスを入力してください")
          expect(current_path).to eq new_user_registration_path
        end
      end

      context "登録済みのメールアドレスを入力" do
        it "ユーザー作成が失敗する" do
          existed_user = create(:user)
          visit new_user_registration_path
          fill_in "user_username", with: "テストユーザー"
          fill_in "user_email", with: existed_user.email
          fill_in "user_password", with: "password"
          fill_in "user_password_confirmation", with: "password"
          click_button "アカウント登録"
          expect(page).to have_content("メールアドレスは既に使用されています")
          expect(current_path).to eq new_user_registration_path
        end
      end

      context "ユーザー名が未入力" do
        it "ユーザー作成が失敗する" do
          visit new_user_registration_path
          fill_in "user_username", with: ""
          fill_in "user_email", with: "animeguru@example.com"
          fill_in "user_password", with: "password"
          fill_in "user_password_confirmation", with: "password"
          click_button "アカウント登録"
          expect(page).to have_content("ユーザー名を入力してください")
          expect(current_path).to eq new_user_registration_path
        end
      end

      context "登録済みのユーザー名を入力" do
        it "ユーザー作成が失敗する" do
          existed_user = create(:user)
          visit new_user_registration_path
          fill_in "user_username", with: existed_user.username
          fill_in "user_email", with: "animeguru@example.com"
          fill_in "user_password", with: "password"
          fill_in "user_password_confirmation", with: "password"
          click_button "アカウント登録"
          expect(page).to have_content("ユーザー名は既に使用されています")
          expect(current_path).to eq new_user_registration_path
        end
      end
    end

    describe "マイページ" do
      context "ログインしていない状態" do
        it "マイページへのアクセスが失敗する" do
          visit "/profile"
          expect(page).to have_content("ログインが必要です")
          expect(current_path).to eq new_user_session_path
        end
      end
    end

    describe "ログイン後" do
      before { login_as(user) }

      describe "ユーザー編集" do
        context "フォームの入力値が正常" do
          it "ユーザー編集が成功する" do
            visit edit_user_registration_path
            fill_in "user_username", with: "アニめぐる"
            fill_in "user_email", with: "animeguru@example.com"
            attach_file("user_profile_image", Rails.root.join("spec/fixtures/files/test.jpg"))
            fill_in "user_introduction", with: "よろしくお願いします。"
            fill_in "user_favorite_anime", with: "ぼっち・ざ・ろっく！"
            click_button "更新"
            expect(page).to have_current_path(profile_path, wait: 10)
            expect(page).to have_text("プロフィールを更新しました", wait: 10)
          end
        end

        context "メールアドレスが未入力" do
          it "ユーザー編集が失敗する" do
            visit edit_user_registration_path
            fill_in "user_username", with: "アニめぐる"
            fill_in "user_email", with: ""
            attach_file("user_profile_image", Rails.root.join("spec/fixtures/files/test.jpg"))
            fill_in "user_introduction", with: "よろしくお願いします。"
            fill_in "user_favorite_anime", with: "ぼっち・ざ・ろっく！"
            click_button "更新"
            expect(page).to have_content("メールアドレスを入力してください")
            expect(current_path).to eq edit_user_registration_path
          end
        end

        context "登録済みのメールアドレスを入力" do
          it "ユーザー編集が失敗する" do
            existed_user = create(:user)
            visit edit_user_registration_path
            fill_in "user_username", with: "アニめぐる"
            fill_in "user_email", with: existed_user.email
            attach_file("user_profile_image", Rails.root.join("spec/fixtures/files/test.jpg"))
            fill_in "user_introduction", with: "よろしくお願いします。"
            fill_in "user_favorite_anime", with: "ぼっち・ざ・ろっく！"
            click_button "更新"
            expect(page).to have_content("メールアドレスは既に使用されています")
            expect(current_path).to eq edit_user_registration_path
          end
        end

        context "ユーザー名が未入力" do
          it "ユーザー編集が失敗する" do
            visit edit_user_registration_path
            fill_in "user_username", with: ""
            fill_in "user_email", with: "animeguru@example.com"
            attach_file("user_profile_image", Rails.root.join("spec/fixtures/files/test.jpg"))
            fill_in "user_introduction", with: "よろしくお願いします。"
            fill_in "user_favorite_anime", with: "ぼっち・ざ・ろっく！"
            click_button "更新"
            expect(page).to have_content("ユーザー名を入力してください")
            expect(current_path).to eq edit_user_registration_path
          end
        end

        context "登録済みのユーザー名を入力" do
          it "ユーザー編集が失敗する" do
            existed_user = create(:user)
            visit edit_user_registration_path
            fill_in "user_username", with: existed_user.username
            fill_in "user_email", with: "animeguru@example.com"
            attach_file("user_profile_image", Rails.root.join("spec/fixtures/files/test.jpg"))
            fill_in "user_introduction", with: "よろしくお願いします。"
            fill_in "user_favorite_anime", with: "ぼっち・ざ・ろっく！"
            click_button "更新"
            expect(page).to have_content("ユーザー名は既に使用されています")
            expect(current_path).to eq edit_user_registration_path
          end
        end

        context "ひとことが未入力" do
          it "ユーザー編集が成功する" do
            visit edit_user_registration_path
            fill_in "user_username", with: "アニめぐる"
            fill_in "user_email", with: "animeguru@example.com"
            attach_file("user_profile_image", Rails.root.join("spec/fixtures/files/test.jpg"))
            fill_in "user_introduction", with: ""
            fill_in "user_favorite_anime", with: "ぼっち・ざ・ろっく！"
            click_button "更新"
            expect(page).to have_content("プロフィールを更新しました")
            expect(current_path).to eq profile_path
          end
        end

        context "好きなアニメ作品が未入力" do
          it "ユーザー編集が成功する" do
            visit edit_user_registration_path
            fill_in "user_username", with: "アニめぐる"
            fill_in "user_email", with: "animeguru@example.com"
            attach_file("user_profile_image", Rails.root.join("spec/fixtures/files/test.jpg"))
            fill_in "user_introduction", with: "よろしくお願いします。"
            fill_in "user_favorite_anime", with: ""
            click_button "更新"
            expect(page).to have_content("プロフィールを更新しました")
            expect(current_path).to eq profile_path
          end
        end

        context "プロフィール画像が未指定" do
          it "ユーザー編集が成功する" do
            visit edit_user_registration_path
            fill_in "user_username", with: "アニめぐる"
            fill_in "user_email", with: "animeguru@example.com"
            fill_in "user_introduction", with: "よろしくお願いします。"
            fill_in "user_favorite_anime", with: "ぼっち・ざ・ろっく！"
            click_button "更新"
            expect(page).to have_content("プロフィールを更新しました")
            expect(current_path).to eq profile_path
          end
        end
      end

      describe "マイページ" do
        context "ログインしている状態" do
          it "マイページへのアクセスが成功する" do
            visit profile_path
            expect(page).to have_content(user.username)
            expect(current_path).to eq profile_path
          end
        end
      end
    end
  end
end
