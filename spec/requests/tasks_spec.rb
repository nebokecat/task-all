require 'rails_helper'

RSpec.describe 'TasksAPI', type: :request do
  describe 'GET /tasks' do
    context '正常系' do
      let!(:task1) { create(:task, id: 1, name: 'task1', finished_at: DateTime.new(2021, 10, 24)) }
      let!(:task2) { create(:task, id: 2, name: 'task2', finished_at: DateTime.new(2021, 10, 26)) }
      let!(:task3) { create(:task, id: 3, name: 'task3', finished_at: DateTime.new(2021, 10, 25)) }

      let(:results) { JSON.parse(response.body) }

      it 'タスク一覧が終了期限順に表示されること' do
        get tasks_path
        expect(results['tasks'][0]['id']).to match(task2.id)
      end
    end
  end

  describe 'POST /tasks' do
    context '正常系' do
      let(:task_create_params) do
        { task: {
          name: 'new_task',
          description: 'task_description'
        } }
      end

      it 'タスクが正しく作成されている' do
        expect { post tasks_path, params: task_create_params }.to change(Task, :count).by(1)
      end
    end

    context '異常系' do
      let(:task_error_params) do
        { task: {
          name: '',
          description: 'task_description'
        } }
      end

      it 'バリデーションエラー' do
        expect { post tasks_path, params: task_error_params }.to change(Task, :count).by(0)
      end
    end
  end

  describe 'GET /tasks/:id' do
    let!(:task1) { create(:task, id: 1, name: 'task1') }
    let!(:task2) { create(:task, id: 2, name: 'task2') }

    context '正常系' do
      let(:results) { JSON.parse(response.body) }

      it '詳細情報が正しく取れている' do
        get task_path(task1)

        expect(results['task']['id']).to eq(task1.id)
      end
    end

    context '異常系' do
      it '存在しないtaskへのページでエラーが出ること' do
        get task_path(3)
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'UPDATE /tasks/:id' do
    let!(:task) { create(:task) }

    context '正常系' do
      let(:task_update_params) do
        { task: {
          name: 'update_task',
          description: 'task_description'
        } }
      end

      it 'タスクが正しく更新されている' do
        patch task_path(task), params: task_update_params

        expect(task.reload.name).to eq(task_update_params[:task][:name])
      end
    end

    context '異常系' do
      let(:task_error_params) do
        { task: {
          name: '',
          description: 'task_description'
        } }
      end

      it 'バリデーションエラー' do
        expect { patch task_path(task), params: task_error_params }.to change(Task, :count).by(0)
        expect(response).to have_http_status(400)
      end
    end
  end

  describe 'DELETE /tasks/:id' do
    let!(:task) { create(:task) }

    it 'タスクが正しく削除されている' do
      expect { delete task_path(task) }.to change(Task, :count).by(-1)
    end
  end
end
