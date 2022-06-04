class UptimesController < ApplicationController
  before_action :set_uptime, only: %i[ show edit update destroy ]

  # GET /uptimes or /uptimes.json
  def index
    @uptimes = Uptime.all
  end

  # GET /uptimes/1 or /uptimes/1.json
  def show
  end

  # GET /uptimes/new
  def new
    @uptime = Uptime.new
  end

  # GET /uptimes/1/edit
  def edit
  end

  # POST /uptimes or /uptimes.json
  def create
    @uptime = Uptime.new(uptime_params)

    respond_to do |format|
      if @uptime.save
        format.html { redirect_to uptime_url(@uptime), notice: "Uptime was successfully created." }
        format.json { render :show, status: :created, location: @uptime }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @uptime.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /uptimes/1 or /uptimes/1.json
  def update
    respond_to do |format|
      if @uptime.update(uptime_params)
        format.html { redirect_to uptime_url(@uptime), notice: "Uptime was successfully updated." }
        format.json { render :show, status: :ok, location: @uptime }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @uptime.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /uptimes/1 or /uptimes/1.json
  def destroy
    @uptime.destroy

    respond_to do |format|
      format.html { redirect_to uptimes_url, notice: "Uptime was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def monitor
    uptimes = Uptime.all
    threads = []

    uptimes.each do |check|
      if check.cancelled
        logger.info "#{check.host} is cancelled."
      else
        logger.info "#{check.host} is active."
        threads << Thread.new { uptime(check) }
      end
    end
  end




  private
    # Use callbacks to share common setup or constraints between actions.
    def set_uptime
      @uptime = Uptime.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def uptime_params
      params.require(:uptime).permit(:host, :interval, :cancelled)
    end


    def uptime(check)
      while check.cancelled == false do
        status = is_it_up(check.host)
        sleep check.interval
        logger.info "#{check.host} is up: #{status}"
      end
    end

    def is_it_up(host)
       ## TODO: Resolve ping requiring sudo privileges
      begin
        p = Net::Ping::ICMP.new(host.to_s, nil, 0.1)
        status = p.ping?
        p.ping? ? status = true : status = false
      rescue Errno::EHOSTUNREACH, Errno::EHOSTDOWN
        return status = false
      end
    end

end
