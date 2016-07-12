module Spree
  class StoreController < Spree::BaseController
    include Spree::Core::ControllerHelpers::Order

    skip_before_action :set_current_order, only: :cart_link

    def forbidden
      render 'spree/shared/forbidden', layout: Spree::Config[:layout], status: 403
    end

    def unauthorized
      render 'spree/shared/unauthorized', layout: Spree::Config[:layout], status: 401
    end

    def cart_link
      render partial: 'spree/shared/link_to_cart'
      fresh_when(simple_current_order)
    end

    protected
      def apply_coupon_code
        if params[:order] && params[:order][:coupon_code]
          @order.coupon_code = params[:order][:coupon_code]
          handler = PromotionHandler::Coupon.new(@order).apply
          if handler.error.present?
            flash.now[:error] = handler.error
            @order.restart_checkout_flow
            redirect_to checkout_state_path(@order.state) && return
          elsif handler.success
            flash[:success] = handler.success
          end
        end
      end
    end

    def config_locale
      Spree::Frontend::Config[:locale]
    end
  end
end
