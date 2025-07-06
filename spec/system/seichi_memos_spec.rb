require 'rails_helper'

RSpec.describe "SeichiMemos", type: :system do
  include LoginMacros
  let!(:user) { create(:user) }
  let!(:seichi_memo) { create(:seichi_memo, user: user) }
  let!(:genre_tag) { create(:genre_tag, :action_battle) }

  describe "ログイン前" do
    describe "聖地メモ新規作成ページにアクセス" do
      it "新規登録ページのアクセスが失敗する" do
        visit new_seichi_memo_path
        expect(page).to have_content("ログインが必要です")
        expect(current_path).to eq new_user_session_path
      end
    end

    describe "聖地メモ編集ページにアクセス" do
      it "編集ページのアクセスが失敗する" do
        visit edit_seichi_memo_path(seichi_memo)
        expect(page).to have_content("ログインが必要です")
        expect(current_path).to eq new_user_session_path
      end
    end

    describe "聖地メモの投稿詳細ページにアクセス" do
      it "一覧ページのアクセスに成功する" do
        seichi_memo_list = create_list(:seichi_memo, 3, user: user)
        visit seichi_memos_path
        expect(page).to have_content(seichi_memo_list[0].title)
        expect(page).to have_content(seichi_memo_list[1].title)
        expect(page).to have_content(seichi_memo_list[2].title)
        expect(current_path).to eq seichi_memos_path
      end
    end

    describe "聖地メモの投稿詳細ページにアクセス" do
      it "詳細ページのアクセスに成功する" do
        visit seichi_memo_path(seichi_memo)
        expect(page).to have_content(seichi_memo.title)
        expect(page).to have_content(seichi_memo.body)
        expect(current_path).to eq seichi_memo_path(seichi_memo)
      end
    end
  end

  describe "ログイン後" do
    before { login_as(user) }

    describe "聖地メモの新規作成" do
      context "フォームの入力値が正常" do
        it "聖地メモの作成が成功する" do
          visit new_seichi_memo_path

          # ステップ1：巡礼記録
          expect(page).to have_text("ステップ 1/4：巡礼記録")
          fill_in "seichi_memo_form_title", with: "アニめぐる"
          fill_in "seichi_memo_form_body", with: "アニめぐるのメモです。"
          attach_file("seichi_memo_form_seichi_photo", Rails.root.join("spec/fixtures/files/test.jpg"))
          attach_file("seichi_memo_form_scene_image", Rails.root.join("spec/fixtures/files/test.jpg"))
          find("#step1-next-button").click
          
          # ステップ２：作品の基本情報
          expect(page).to have_text("ステップ 2/4：作品の基本情報")
          fill_in "seichi_memo_form_anime_title", with: "アニめぐるの冒険"
          fill_in "seichi_memo_form_anime_official_site_url", with: "https://www.animeguru.jp/"
          attach_file("seichi_memo_form_image_url", Rails.root.join("spec/fixtures/files/test.jpg"))
          find('label[for="genre-modal-toggle"]').click
          check genre_tag.name
          find('label[for="genre-modal-toggle"]').click
          find('#step2-next-button').click

          # ステップ3：聖地の基本情報
          expect(page).to have_text("ステップ 3/4：聖地の基本情報")
          fill_in "seichi_memo_form_place_name", with: "アニめぐるの聖地"
          fill_in "seichi_memo_form_place_address", with: "東京都千代田区1-1-1"
          fill_in "seichi_memo_form_place_postal_code", with: "100-0001"
          click_button "確認画面へ"

          # ステップ4：確認画面
          expect(page).to have_text("ステップ 4/4：確認画面")
          expect(page).to have_text("アニめぐる")
          expect(page).to have_text("アニめぐるのメモです。")
          expect(page).to have_text("アニめぐるの冒険")
          expect(page).to have_text("https://www.animeguru.jp/")
          expect(page).to have_text("アニめぐるの聖地")
          expect(page).to have_text("東京都千代田区1-1-1")
          expect(page).to have_text("100-0001")
          expect(page).to have_text("アクション/バトル")
          click_button "投稿する"

          # 投稿完了メッセージの確認
          expect(page).to have_text("聖地メモを投稿しました！")
          expect(current_path).to eq seichi_memo_path(seichi_memo)
        end
      end

      context "ステップ 1/4：巡礼記録の入力が不正" do
        it "聖地メモの作成が失敗する" do
          visit new_seichi_memo_path

          # ステップ1：巡礼記録
          expect(page).to have_text("ステップ 1/4：巡礼記録")
          fill_in "seichi_memo_form_title", with: ""
          fill_in "seichi_memo_form_body", with: ""
          attach_file("seichi_memo_form_seichi_photo", Rails.root.join("spec/fixtures/files/test.jpg"))
          attach_file("seichi_memo_form_scene_image", Rails.root.join("spec/fixtures/files/test.jpg"))
          find("#step1-next-button").click
          expect(page).to have_text("タイトルを入力してください")
          expect(page).to have_text("メモを入力してください")
        end
      end

      context "ステップ 2/4：作品の基本情報の入力が不正" do
        it "聖地メモの作成が失敗する" do
          visit new_seichi_memo_path
          # ステップ1：巡礼記録
          expect(page).to have_text("ステップ 1/4：巡礼記録")
          fill_in "seichi_memo_form_title", with: "アニめぐる"
          fill_in "seichi_memo_form_body", with: "アニめぐるのメモです。"
          attach_file("seichi_memo_form_seichi_photo", Rails.root.join("spec/fixtures/files/test.jpg"))
          attach_file("seichi_memo_form_scene_image", Rails.root.join("spec/fixtures/files/test.jpg"))
          find("#step1-next-button").click

          # ステップ2：作品の基本情報
          expect(page).to have_text("ステップ 2/4：作品の基本情報")
          fill_in "seichi_memo_form_anime_title", with: ""
          fill_in "seichi_memo_form_anime_official_site_url", with: ""
          attach_file("seichi_memo_form_image_url", Rails.root.join("spec/fixtures/files/test.jpg"))
          find('label[for="genre-modal-toggle"]').click
          check genre_tag.name
          find('label[for="genre-modal-toggle"]').click
          find('#step2-next-button').click
          expect(page).to have_text("作品タイトルを入力してください")
        end
      end

      context "ステップ 3/4：聖地の基本情報の入力が不正" do
        it "聖地メモの作成が失敗する" do
          visit new_seichi_memo_path
          # ステップ1：巡礼記録
          expect(page).to have_text("ステップ 1/4：巡礼記録")
          fill_in "seichi_memo_form_title", with: "アニめぐる"
          fill_in "seichi_memo_form_body", with: "アニめぐるのメモです。"
          attach_file("seichi_memo_form_seichi_photo", Rails.root.join("spec/fixtures/files/test.jpg"))
          attach_file("seichi_memo_form_scene_image", Rails.root.join("spec/fixtures/files/test.jpg"))
          find("#step1-next-button").click

          # ステップ2：作品の基本情報
          expect(page).to have_text("ステップ 2/4：作品の基本情報")
          fill_in "seichi_memo_form_anime_title", with: "アニめぐるの冒険"
          fill_in "seichi_memo_form_anime_official_site_url", with: "https://www.animeguru.jp/"
          attach_file("seichi_memo_form_image_url", Rails.root.join("spec/fixtures/files/test.jpg"))
          find('label[for="genre-modal-toggle"]').click
          check genre_tag.name
          find('label[for="genre-modal-toggle"]').click
          find('#step2-next-button').click

          # ステップ3：聖地の基本情報
          expect(page).to have_text("ステップ 3/4：聖地の基本情報")
          fill_in "seichi_memo_form_place_name", with: ""
          click_button "確認画面へ"
          expect(page).to have_text("聖地名を入力してください")
        end
      end

      context "ステップを戻る" do
        it "ステップを戻るボタンが正しく機能する" do
          visit new_seichi_memo_path

          # ステップ1：巡礼記録
          expect(page).to have_text("ステップ 1/4：巡礼記録")
          fill_in "seichi_memo_form_title", with: "アニめぐる"
          fill_in "seichi_memo_form_body", with: "アニめぐるのメモです。"
          attach_file("seichi_memo_form_seichi_photo", Rails.root.join("spec/fixtures/files/test.jpg"))
          attach_file("seichi_memo_form_scene_image", Rails.root.join("spec/fixtures/files/test.jpg"))
          find("#step1-next-button").click

          # ステップ2：作品の基本情報
          expect(page).to have_text("ステップ 2/4：作品の基本情報")
          find("#step2-back-button").click

          # ステップ1に戻ることを確認
          expect(page).to have_text("ステップ 1/4：巡礼記録")
        end
      end
    end

    describe "聖地メモの編集" do
      context "フォームの入力値が正常" do
        it "聖地メモの編集が成功する" do
          visit edit_seichi_memo_path(seichi_memo)

          # ステップ1：巡礼記録
          expect(page).to have_text("ステップ 1/4：巡礼記録")
          fill_in "seichi_memo_form_title", with: "アニめぐるの編集"
          fill_in "seichi_memo_form_body", with: "アニめぐるのメモを編集しました。"
          attach_file("seichi_memo_form_seichi_photo", Rails.root.join("spec/fixtures/files/test.jpg"))
          attach_file("seichi_memo_form_scene_image", Rails.root.join("spec/fixtures/files/test.jpg"))
          find("#step1-next-button").click

          # ステップ2：作品の基本情報
          expect(page).to have_text("ステップ 2/4：作品の基本情報")
          fill_in "seichi_memo_form_anime_title", with: "アニめぐるの冒険"
          fill_in "seichi_memo_form_anime_official_site_url", with: "https://www.animeguru.jp/"
          attach_file("seichi_memo_form_image_url", Rails.root.join("spec/fixtures/files/test.jpg"))
          find('label[for="genre-modal-toggle"]').click
          check genre_tag.name
          find('label[for="genre-modal-toggle"]').click
          find('#step2-next-button').click

          # ステップ3：聖地の基本情報
          expect(page).to have_text("ステップ 3/4：聖地の基本情報")
          fill_in "seichi_memo_form_place_name", with: "アニめぐるの聖地"
          fill_in "seichi_memo_form_place_address", with: "東京都千代田区1-1-1"
          fill_in "seichi_memo_form_place_postal_code", with: "100-0001"
          click_button "確認画面へ"

          # ステップ4：確認画面
          expect(page).to have_text("ステップ 4/4：確認画面")
          expect(page).to have_text("アニめぐるの編集")
          expect(page).to have_text("アニめぐるのメモを編集しました。")
          expect(page).to have_text("アニめぐるの冒険")
          expect(page).to have_text("https://www.animeguru.jp/")
          expect(page).to have_text("アニめぐるの聖地")
          expect(page).to have_text("東京都千代田区1-1-1")
          expect(page).to have_text("100-0001")
          expect(page).to have_text("アクション/バトル")
          click_button "更新する"
          expect(page).to have_text("聖地メモを更新しました！")
          expect(current_path).to eq seichi_memo_path(seichi_memo)
        end
      end

      context "ステップ 1/4：巡礼記録の入力が不正" do
        it "聖地メモの編集が失敗する" do
          visit edit_seichi_memo_path(seichi_memo)

          # ステップ1：巡礼記録
          expect(page).to have_text("ステップ 1/4：巡礼記録")
          fill_in "seichi_memo_form_title", with: ""
          fill_in "seichi_memo_form_body", with: ""
          attach_file("seichi_memo_form_seichi_photo", Rails.root.join("spec/fixtures/files/test.jpg"))
          attach_file("seichi_memo_form_scene_image", Rails.root.join("spec/fixtures/files/test.jpg"))
          find("#step1-next-button").click
          expect(page).to have_text("タイトルを入力してください")
          expect(page).to have_text("メモを入力してください")
        end
      end

      context "ステップ 2/4：作品の基本情報の入力が不正" do
        it "聖地メモの編集が失敗する" do
          visit edit_seichi_memo_path(seichi_memo)

          # ステップ1：巡礼記録
          expect(page).to have_text("ステップ 1/4：巡礼記録")
          fill_in "seichi_memo_form_title", with: "アニめぐるの編集"
          fill_in "seichi_memo_form_body", with: "アニめぐるのメモを編集しました。"
          attach_file("seichi_memo_form_seichi_photo", Rails.root.join("spec/fixtures/files/test.jpg"))
          attach_file("seichi_memo_form_scene_image", Rails.root.join("spec/fixtures/files/test.jpg"))
          find("#step1-next-button").click

          # ステップ2：作品の基本情報
          expect(page).to have_text("ステップ 2/4：作品の基本情報")
          fill_in "seichi_memo_form_anime_title", with: ""
          attach_file("seichi_memo_form_image_url", Rails.root.join("spec/fixtures/files/test.jpg"))
          find('label[for="genre-modal-toggle"]').click
          check genre_tag.name
          find('label[for="genre-modal-toggle"]').click
          find('#step2-next-button').click
          expect(page).to have_text("作品タイトルを入力してください")
        end
      end
      context "ステップ 3/4：聖地の基本情報の入力が不正" do
        it "聖地メモの編集が失敗する" do
          visit edit_seichi_memo_path(seichi_memo)

          # ステップ1：巡礼記録
          expect(page).to have_text("ステップ 1/4：巡礼記録")
          fill_in "seichi_memo_form_title", with: "アニめぐるの編集"
          fill_in "seichi_memo_form_body", with: "アニめぐるのメモを編集しました。"
          attach_file("seichi_memo_form_seichi_photo", Rails.root.join("spec/fixtures/files/test.jpg"))
          attach_file("seichi_memo_form_scene_image", Rails.root.join("spec/fixtures/files/test.jpg"))
          find("#step1-next-button").click

          # ステップ2：作品の基本情報
          expect(page).to have_text("ステップ 2/4：作品の基本情報")
          fill_in "seichi_memo_form_anime_title", with: "アニめぐるの冒険"
          fill_in "seichi_memo_form_anime_official_site_url", with: "https://www.animeguru.jp/"
          attach_file("seichi_memo_form_image_url", Rails.root.join("spec/fixtures/files/test.jpg"))
          find('label[for="genre-modal-toggle"]').click
          check genre_tag.name
          find('label[for="genre-modal-toggle"]').click
          find('#step2-next-button').click

          # ステップ3：聖地の基本情報
          expect(page).to have_text("ステップ 3/4：聖地の基本情報")
          fill_in "seichi_memo_form_place_name", with: ""
          click_button "確認画面へ"
          expect(page).to have_text("聖地名を入力してください")
        end
      end

      context "ステップを戻る" do
        it "ステップを戻るボタンが正しく機能する" do
          visit edit_seichi_memo_path(seichi_memo)

          # ステップ1：巡礼記録
          expect(page).to have_text("ステップ 1/4：巡礼記録")
          fill_in "seichi_memo_form_title", with: "アニめぐるの編集"
          fill_in "seichi_memo_form_body", with: "アニめぐるのメモを編集しました。"
          attach_file("seichi_memo_form_seichi_photo", Rails.root.join("spec/fixtures/files/test.jpg"))
          attach_file("seichi_memo_form_scene_image", Rails.root.join("spec/fixtures/files/test.jpg"))
          find("#step1-next-button").click

          # ステップ2：作品の基本情報
          expect(page).to have_text("ステップ 2/4：作品の基本情報")
          find("#step2-back-button").click

          # ステップ1に戻ることを確認
          expect(page).to have_text("ステップ 1/4：巡礼記録")
        end
      end
    end
    describe "聖地メモの削除" do
      it "聖地メモの削除が成功する" do
        visit seichi_memo_path(seichi_memo)

        # 削除ボタンをクリック
        accept_confirm do
          click_link "削除"
        end

        # 削除完了メッセージの確認
        expect(page).to have_text("聖地メモを削除しました")
        expect(current_path).to eq seichi_memos_path
      end
    end
  end
end
