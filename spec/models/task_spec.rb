require 'rails_helper'

RSpec.describe Task, type: :model do
  before do
    @task = build(:task)
  end

  describe 'バリデーション' do
    context '正常形' do
      it 'タイトルと説明文がある場合' do
        expect(@task).to be_valid
      end
    end

    context '異常形' do
      it 'タイトルが空の場合' do
        @task.name = ''
        expect(@task).to be_invalid
      end
      it '説明文が空の場合' do
        @task.description = ''
        expect(@task).to be_invalid
      end
    end
  end
end
