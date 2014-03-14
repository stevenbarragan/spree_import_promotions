class ImportPromotionPresenter < SimpleDelegator
  def initialize(info)
    @info = info
  end

  def import_processed
    @all ||= @info.import_promotion_datas.count
  end

  def import_updated
    @updated ||= @info.import_promotion_updated.count
  end

  def import_errors
    @errors ||= @info.import_promotion_errors.count
  end

  def import_new
    @new ||= @info.import_promotion_new.count
  end

  def method_missing(method, *args)
    @info.send(method, *args)
  end
end
