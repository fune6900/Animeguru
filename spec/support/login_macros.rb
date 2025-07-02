module LoginMacros
  def login_as(user)
    visit new_user_session_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: user.password
    click_button 'ログイン'
    expect(page).to have_content("ログインしました。さっそく聖地メモを投稿してみませんか？")
  end
end
