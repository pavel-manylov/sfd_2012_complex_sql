#coding: utf-8
class ActiveRecord::Relation
  def add_select(selects)
    t=self.scoped
    selects=[selects] unless selects.kind_of?(Array)
    t.select_values = [self.arel_table[Arel.star]] if t.select_values.blank?
    t.select_values+=selects
    t
  end
end