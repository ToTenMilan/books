class TasksController < ApplicationController
  before_action :find_task, only: [:show, :edit, :update, :destroy]
  def index
    @tasks = Task.all.order('created_at DESC')
  end
  
  def show
  end

  def new
    @task = Task.new
  end
  
  def create
    @task = Task.new(task_params)
    if @task.save
      flash[:success] = "Task successfully created"
      redirect_to @task
    else
      flash[:error] = "Something went wrong"
      render 'new'
    end
  end

  def edit
  end
  
  def create
    @task = Task.new(task_params)
    if @task.save
      flash[:success] = "Task successfully created"
      redirect_to @task
    else
      flash[:error] = "Something went wrong"
      render 'new'
    end
  end
  
  def update
    if @task.update_attributes(task_params)
      flash[:success] = "Task was successfully updated"
      redirect_to @task
    else
      flash[:error] = "Something went wrong"
      render 'edit'
    end
  end
  
  def destroy
    if @task.destroy
      flash[:success] = 'Task was successfully deleted.'
      redirect_to tasks_url
    else
      flash[:error] = 'Something went wrong'
      redirect_to tasks_url
    end
  end
  
  private

    def task_params
      params.require(:task).permit(:title, :description, :company, :url)
    end

    def find_task
      @task = Task.find(params[:id])
    end
end
