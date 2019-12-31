class VersionsController < ApplicationController
  #before_action :set_version, only: [:show, :edit, :update, :destroy]
  before_action :set_version, only: [:rollback]

  # GET /versions/:id/rollback(.:format)
  def rollback
    #render plain: "#{@version.reify}  --- #{@version.reify.inspect}"
    respond_to do |format|
      if @version.reify.save
        format.html { redirect_to @version.reify, notice: 'Version was successfully restored.' }
      else
        format.html { redirect_to @version.reify, warning: 'Rollback Failed.' }
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_version
      @version = PaperTrail::Version.find(params[:id])
    end

end
