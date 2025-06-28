require 'rails_helper'

RSpec.describe SeichiMemo, type: :model do
  describe 'バリデーションチェック' do
    it '設定したすべてのバリデーションが機能しているか' do
      seichi_memo = FactoryBot.build(:seichi_memo)
      expect(seichi_memo).to be_valid
    end

    it 'titleが空だと無効になる' do
      seichi_memo = FactoryBot.build(:seichi_memo, title: '')
      expect(seichi_memo).to be_invalid
      expect(seichi_memo.errors[:title]).to include('を入力してください')
    end

    it 'titleが31文字以上だと無効になる' do
      seichi_memo = FactoryBot.build(:seichi_memo, title: 'あ' * 31)
      expect(seichi_memo).to be_invalid
      expect(seichi_memo.errors[:title]).to include('は30文字以内で入力してください')
    end

    it 'bodyが空だと無効になる' do
      seichi_memo = FactoryBot.build(:seichi_memo, body: '')
      expect(seichi_memo).to be_invalid
      expect(seichi_memo.errors[:body]).to include('を入力してください')
    end

    it 'bodyが501文字以上だと無効になる' do
      seichi_memo = FactoryBot.build(:seichi_memo, body: 'あ' * 501)
      expect(seichi_memo).to be_invalid
      expect(seichi_memo.errors[:body]).to include('は500文字以内で入力してください')
    end
  end
end
