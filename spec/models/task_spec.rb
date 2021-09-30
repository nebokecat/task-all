require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:task) { build(:task) }

  describe 'バリデーション' do
    subject { task }
    context '正常形' do
      it 'タイトルと説明文がある場合' do
        is_expected.to be_valid
      end
    end

    context '異常形' do
      it 'タイトルが空の場合' do
        task.name = nil
        is_expected.to be_invalid
      end

      it '説明文が空の場合' do
        task.description = nil
        is_expected.to be_invalid
      end
    end
  end
end
