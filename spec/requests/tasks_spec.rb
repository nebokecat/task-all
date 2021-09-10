require 'rails_helper'

RSpec.describe 'TasksAPI', type: :request do
  describe 'GET /tasks' do
    it 'タスク一覧が新規作成順に表示されること' do
      get tasks_path
      json = JSON.parse(response.body)
      last_task = Task.order(:created_at).last
      expect(json['tasks'][0]['id']).to eq(last_task.id)
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /tasks' do
    before do
      @task_create_params = {
        task: {
          name: 'task_name',
          description: 'task_description'
        }
      }
    end

    it 'タスクが正しく作成されている' do
      expect { post tasks_path, params: @task_create_params }.to change(Task, :count).by(1)
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /tasks/:id' do
    before do
      @task = Task.last
    end

    it '詳細情報が正しく取れている' do
      get task_path(@task)
      json = JSON.parse(response.body)
      expect(json['task']['id']).to eq(@task.id)
      expect(response).to have_http_status(200)
    end
  end

  describe 'PATCH /tasks/:id' do
    before do
      @task = create(:task)
      @task_update_params = {
        task: {
          name: 'new_task'
        }
      }
    end

    it 'タスクが正しく更新されている' do
      patch task_path(@task), params: @task_update_params
      expect(@task.reload.name).to eq(@task_update_params[:task][:name])
      expect(response).to have_http_status(200)
    end
  end

  describe 'DELETE /tasks/:id' do
    before do
      @task = create(:task)
    end

    it 'タスクが正しく削除されている' do
      expect { delete task_path(@task) }.to change(Task, :count).by(-1)
      expect(response).to have_http_status(204)
    end
  end
end
