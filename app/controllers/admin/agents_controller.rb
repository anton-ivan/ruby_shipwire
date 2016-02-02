class Admin::AgentsController < Admin::ApplicationController  
  before_action :find_agent, only: [:edit, :update, :destroy, :orders]
  
  def index
    @agents = Agent.all.order("created_at desc").page(params[:page]).per_page(10) 
  end
  
  def new
    @agent = Agent.new
  end
  
  def create
    @agent = Agent.new(agents_params)

    if @agent.save
      redirect_to '/admin/agents', notice: 'Agent was successfully created.'
    else
      render action: 'new'
    end
  end
  
  def orders
    @orders = Order.where("referer =?",@agent.name).page(params[:page]).per_page(10) 
  end

  def update
    if @agent.update(agent_params)
       redirect_to '/admin/agents', notice: 'Agent was successfully updated.'
    else
      render action: 'edit'
    end    
  end
  
  def destroy
    @agent.destroy
    redirect_to admin_agents_url, notice: 'Agent was successfully destroyed.'    
  end  
  
  private 
  
  def find_agent
    @agent = Agent.find params[:id]
  end 

  def agents_params
    params.require(:agent).permit(:name,:email)
  end
      
end
