# タスク管理アプリケーション

## マイグレーション

### NOT NULL制約
task.nameにNOTNULL制約を追加
```
$ bin/rails g migration ChangeTasksNameNotNull
Running via Spring preloader in process 29289
      invoke  active_record
      create    db/migrate/20200912142736_change_tasks_name_not_null.rb
```
DBにマイグレーション適用
```
$ bin/rails db:migrate
```

### 文字列カラムの長さを指定
テーブル作成時に指定
```
create_table :tasks do |t|
  t.string :name, limit: 30, null: false
```

テーブル作成後に指定
```
class ChangeTasksNameLimit30 < ActiveRecord::Migration[5.2]
  def up
    change_column :tasks, :name, :string, limit: 30
  end
  def down
    change_column :tasks, :name, :string
  end
end
```

### ユニークインデックス
一意性
```
add_index :tasks, :name, unique: true
```

## モデルの検証
### 必須
taskモデルを修正
```
class Task < ApplicationRecord
  validates :name, presence: true
end
```
### 検証エラーに対応（コントローラ、ビュー）
taskleaf/app/controllers/tasks_controller.rb
createメソッドを修正
修正前
```
def create
  task = Task.new(task_params)
  task.save!
  flash[:info] = "タスク「#{task.name}」を登録しました。"
  redirect_to tasks_url
end
```
修正後
変更点
- save! を saveに変更
- saveがfalse（エラー）の場合、新規登録画面に戻す
- @task で、エラー後に新規登録画面に表示するtaskを保持
```
def create
  @task = Task.new(task_params)
  if task.save
    flash[:info] = "タスク「#{@task.name}」を登録しました。"
    redirect_to @task
  else
    render :new
  end
end
```

taskleaf/app/views/tasks/_form.html.slim
ビューを変更しエラーメッセージを表示する
```
- if @task.errors.present?
  ul#error_expanation
    -task.errors.full_messages.each do |msg|
      li= msg
```

### 文字列長の検証
```
  validates :name, length: { maximum: 30 }
```

### オリジナルの検証コード
オリジナルの検証コードの書き方は２通りある
1. 検証を行うメソッドを追加
2. Validatorを作る

検証「name属性には,(カンマ)が含まれていてはいけない」

検証を追加するステップ
1. モデルクラスに検証用メソッドを追加
2. 検証用メソッドを実装
```
validate :validate_name_not_including_comma

private

def validate_name_not_including_comma
  errors.add(:name, 'にカンマを含めることはできません') if name&.include?(',')
end
```

## コールバック
モデルの状態を自動的に制御する
