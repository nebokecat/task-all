require 'rails_helper'

RSpec.describe 'TasksAPI', type: :request do
  describe 'GET /tasks' do
    context '正常系' do
      let!(:task1) { create(:task, id: 1, name: 'task1') }
      let!(:task2) { create(:task, id: 2, name: 'task2') }

      let(:json) { JSON.parse(response.body) }

      it 'タスク一覧が新規作成順に表示されること' do
        get tasks_path

        expect(json['tasks'][0]["id"]).to match(task2.id)
        expect(json['tasks'][1]["id"]).to match(task1.id)
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'POST /tasks' do
    context '正常系' do
      # let は2行以上になるのであれば、do~end ブロックにしたほうがいい
      let(:task_create_params) do
        { task: {
            name: 'new_task',
            description: 'task_description'
          }
        }
      end

      it 'タスクが正しく作成されている' do
        expect { post tasks_path, params: task_create_params }.to change(Task, :count).by(1)
        expect(response).to have_http_status(200)
      end
    end

    context '異常系' do
      let(:task_error_params) do
        { task: {
            name: '',
            description: 'task_description'
          }
        }
      end

      it 'バリデーションエラー' do
        expect { post tasks_path, params: task_error_params }.to change(Task, :count).by(0)
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'GET /tasks/:id' do
    let!(:task1) { create(:task, id: 1, name: 'task1') }
    let!(:task2) { create(:task, id: 2, name: 'task2') }

    context '正常系' do
      # id: 1 と、id: 2 の別々のTaskデータを用意して、
      # expectではid: 1が取れている
      it '詳細情報が正しく取れている' do
        get task_path(task1)

        # let(:json) { JSON.parse(response.body) }
        json = JSON.parse(response.body)

        expect(json['task']['id']).to eq(task1.id)
        expect(response).to have_http_status(200)
      end
    end

    # レスポンスのステータスコード404が検証できれば良い
    context '異常系' do
      it '存在しないtaskへのページでエラーが出ること' do
        get task_path(3)
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'UPDATE /tasks/:id' do
    context '正常系' do

      let(:task) { create(:task) }
      let(:task_update_params) do
        { task: {
            name: 'update_task',
            description: 'task_description'
          }
        }
      end

      it 'タスクが正しく更新されている' do
        patch task_path(task), params: task_update_params
        # patch task_path(task), params: task_update_params

        expect(task.reload.name).to eq(task_update_params[:task][:name])
        expect(response).to have_http_status(200)
      end
    end

    context '異常系' do
      let(:task_error_params) do
        { task: {
            name: '',
            description: 'task_description'
          }
        }
      end

      it 'バリデーションエラー' do
        expect { post tasks_path, params: task_error_params }.to change(Task, :count).by(0)
        expect(response).to have_http_status(200)
      end
    end
  end

  # 異常系不要
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
