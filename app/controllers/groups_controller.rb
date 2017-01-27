class GroupsController < ApplicationController
  before_action :authenticate_user! , only: [:new, :create, :edit, :update, :destroy]
  before_action :find_group_and_check_premission, only: [:edit, :update, :destroy]
    def index
    @groups = Group.all
  end
    def show
    @group = Group.find(params[:id])
    @posts = @group.posts.recent.paginate(:page => params[:page], :per_page =>5)
 end
     def edit
     @group = Group.find(params[:id])
 end
   def new
   @group = Group.new
 end
 def create
    @group = Group.new(group_params)
    @group.user = current_user

    if @group.save
      redirect_to groups_path
    else
      render :new
    end
  end
  def update
     @group = Group.find(params[:id])
     if @group.update(group_params)
       redirect_to groups_path, notice: "更新成功"
     else
       render :edit
     end
   end
  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    redirect_to groups_path,  alert: "删除成功"
  end
  def join
    @group = Group.find(params[:id])
    if  !current_user. is_member_of?(@group)
      current_user.join!(@group)
      flash[:notice] = "欢迎加入本讨论版"
    else
      flash[:warning] = "你已经是本组成员"
    end
    redirect_to groups_path(@group)

  end
  def quit
    @group = Group.find(params[:id])
    if  !current_user. is_member_of?(@group)
      current_user.quit!(@group)
      flash[:notice] = "你自由了，嘿嘿"
    else
      flash[:warning] = "拜拜喽"

    end
    redirect_to group_path(@group)

  end

 private
 def find_group_and_check_premission
  @group = Group.find(params[:id])
    if current_user != @group.user
      redirect_to root_path, alert: "你没有权限"

    end
 end

 def group_params
   params.require(:group).permit(:title, :description)
 end
end
