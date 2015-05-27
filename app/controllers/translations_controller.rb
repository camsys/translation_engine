class TranslationsController < ApplicationController
  before_action :set_Translation, only: [:show, :edit, :update, :destroy]

  # GET /Translations
  def index
    @translations = Translation.all
  end

  # GET /Translations/1
  def show
  end

  # GET /Translations/new
  def new
    @translation = Translation.new
  end

  # GET /Translations/1/edit
  def edit
  end

  # POST /Translations
  def create
    @translation = Translation.new(Translation_params)

    if @translation.save
      redirect_to @translation, notice: 'Translation was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /Translations/1
  def update
    if @translation.update(Translation_params)
      redirect_to @translation, notice: 'Translation was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /Translations/1
  def destroy
    @translation.destroy
    redirect_to Translations_url, notice: 'Translation was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_Translation
      @translation = Translation.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def Translation_params
      params.require(:Translation).permit(:locale_id, :key, :value)
    end
end
