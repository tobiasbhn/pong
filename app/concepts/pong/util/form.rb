module Pong::Util::Form
  def no_validation?(model)
    # determines if a form is shown initially or after an error
    model.input_params.blank?
  end

  def validation_class(model, attribute)
    if model.respond_to?(:errors) && model.errors.key?(attribute.to_sym) && !no_validation?(model)
      ' is-invalid'
    end
  end

  def validation_text(model, attribute)
    if no_validation?(model)
      ''
    elsif model.respond_to?(:errors) && model.errors.key?(attribute.to_sym)
      content_tag :div, model.errors.messages[attribute.to_sym].first, class: 'invalid-feedback'
    else
      content_tag :div, "Looking good!", class: 'valid-feedback'
    end
  end
end