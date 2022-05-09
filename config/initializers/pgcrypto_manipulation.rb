module PGCrypto::Manipulation
  class << self

    private

    def translate_child( child )
      return child unless child.respond_to?(:left) && child.left.respond_to?(:relation)
      table_name = child.left.relation.name
      columns    = PGCrypto[ table_name ]
      return child unless columns.present?
      return child unless options = columns[ child.left.name.to_s ]
      key        = PGCrypto.keys.private_key( options )
      child.left = PGCrypto::Crypt.decrypt_column(table_name, child.left.name, key)

      # Prevent ActiveRecord from re-casting the value to binary
      case child.right
      when String
        child.right = quoted_literal( child.right )
      when Arel::Nodes::Casted
        if Hash === child.right.val
          if child.right.val.key?( :value )
            child.right = quoted_literal( child.right.val[ :value ] )
          else raise "Unknown value format presented to block in translate_child: #{child.right.val.inspect}!"
          end
        else
          child.right = quoted_literal( child.right.val )
        end
      when Array
        child.right = child.right.map do |item|
          case item
          when Arel::Nodes::Casted
            quoted_literal( item.val )
          else
            raise "Unknown node class presented to block in translate_child: #{item.class.to_s}!"
          end
        end
      when Arel::Nodes::BindParam
        # Do nothing -- ActiveRecord will pass the correct binding and cast it appropriately.
      else
        raise "Unknown node class presented to translate_child: #{child.right.class.to_s}!"
      end
    end

  end
end
