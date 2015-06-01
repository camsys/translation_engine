class TranslationsController < ApplicationController
  
  before_action :set_translation, only: [:show, :edit, :update, :destroy]

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
    @translation = Translation.new(translation_params)

    if @translation.save
      redirect_to translation_engine.translation_path(@translation), notice: 'Translation was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /Translations/1
  def update
    if @translation.update(translation_params)
      redirect_to @translation, notice: 'Translation was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /Translations/1
  def destroy
    @translation.destroy
    redirect_to translations_url, notice: 'Translation was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_translation
      @translation = Translation.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def translation_params
      params.require(:translation).permit(:locale_id, :translation_key_id, :value)
    end
end
