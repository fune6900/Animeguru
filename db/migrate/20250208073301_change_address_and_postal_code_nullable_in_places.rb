class ChangeAddressAndPostalCodeNullableInPlaces < ActiveRecord::Migration[7.2]
  def change
    change_column_null :places, :address, true
    change_column_null :places, :postal_code, true
  end
end
