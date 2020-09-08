# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    super
  end

  # POST /resource
  def create
    unless params[:sekurfrazo].strip.downcase == 'esperanto'
      redirect_to(new_registration_path(resource_name), flash: { error: 'Sekurfrazo ne valida' }) and return
    end

    super
    NovaUzantoSciigoJob.perform_now(resource)
  end

  # GET /resource/edit
  def edit
    super
  end

  # PUT /resource
  def update
    registras_instru_informojn
    registras_preleg_informojn
    super
  end

  # DELETE /resource
  def destroy
    super
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  def cancel
    super
  end

  protected

    # If you have extra params to permit, append them to the sanitizer.
    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: %i[name city country_id birthday ueacode])
    end

    # If you have extra params to permit, append them to the sanitizer.
    def configure_account_update_params
      devise_parameter_sanitizer.permit(:account_update, keys: %i[name picture city country_id weekly_summary birthday ueacode about youtube telegram instagram facebook vk instruisto preleganto])
    end

    # The path used after sign up.
    def after_sign_up_path_for(resource)
      super(resource)
    end

    # The path used after sign up for inactive accounts.
    def after_inactive_sign_up_path_for(resource)
      super(resource)
    end

    # Ĝi estas necesa por ke la uzanto povas ŝanĝi viajn informojn senpasvorte.
    def update_resource(resource, params)
      resource.update_without_password(params)
    end

    # Alidirektas la uzanton al sia profila paĝo
    def after_update_path_for(resource)
      events_by_username_path(resource.username)
    end

  private

    def registras_instru_informojn
      if params[:user][:instruisto].present?
        resource.instruisto        = true
        resource.instruo['nivelo'] = params[:nivelo].keys
        resource.instruo['sperto'] = params[:instru_sperto]
      else
        resource.instruo.delete('instruisto')
        resource.instruo.delete('nivelo')
        resource.instruo.delete('sperto')
      end
      resource.save
    end

    def registras_preleg_informojn
      if params[:user][:preleganto].present?
        resource.preleganto        = true
        resource.prelego['temoj'] = params[:preleg_temoj]
      else
        resource.prelego.delete('preleganto')
        resource.prelego.delete('temoj')
      end
      resource.save
    end

end
