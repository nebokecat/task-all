require 'rails_helper'

RSpec.describe 'TasksAPI', type: :request do
  describe 'GET /tasks' do
    context '正常系' do
      let!(:task1) do
        create(:task, id: 1, name: 'task1', created_at: DateTime.new(2021, 9, 25), finished_at: DateTime.new(2021, 9, 25),
                      status: 0)
      end
      let!(:task2) do
        create(:task, id: 2, name: 'task2', created_at: DateTime.new(2021, 9, 23), finished_at: DateTime.new(2021, 9, 24),
                      status: 0)
      end
      let!(:task3) do
        create(:task, id: 3, name: 'task3', created_at: DateTime.new(2021, 9, 26), finished_at: DateTime.new(2021, 9, 24),
                      status: 1)
      end
      let!(:task4) do
        create(:task, id: 4, name: 'task4', created_at: DateTime.new(2021, 9, 24), finished_at: DateTime.new(2021, 9, 26),
                      status: 2)
      end
      let!(:task5) do
        create(:task, id: 5, name: 'タスク5', created_at: DateTime.new(2021, 9, 27), finished_at: DateTime.new(2021, 9, 27),
                      status: 0)
      end

      let(:tasks) { JSON.parse(response.body)['tasks'] }

      it 'パラメータがない時、データ全てが作成日時の降順で取得できていること' do
        get tasks_path
        expect(tasks.count).to eq(5)
        expect(tasks[0]['id']).to match(task2.id)
      end

      it 'ソート機能 終了期限 descソートができている' do
        get tasks_path(sort_column: 'finished_at', sort_method: 'desc')
        expect(tasks.count).to eq(5)
        expect(tasks[0]['id']).to match(task5.id)
      end

      context '検索あり' do
        it 'status検索' do
          get tasks_path(status: 0)
          expect(tasks.count).to eq(3)
        end
        it 'title検索' do
          get tasks_path(title: 'task3')
          expect(tasks[0]['id']).to eq(task3.id)
          expect(tasks.count).to eq(1)
        end
        it 'status & title 検索' do
          # 名前が部分検索になっていることも確認する
          get tasks_path(status: 0, title: 'task')
          expect(tasks[0]['id']).to eq(task2.id)
          expect(tasks.count).to eq(2)
        end
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
