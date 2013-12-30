module MSISDN
  class Sanitizer

    ALLOWED_CODES = {in: %w(0091 +91 0)}
    ALLOWED_FORMATS = %w( local international )
    CLEANUP_REGEX = /[^0-9A-Za-z+]/

    class << self

      def sanitize(msisdns, options = {})

        options.reverse_merge!(
            :country_code => :in,
            :format => 'international'
        )

        raise(InvalidArgumentTypeException, 'Argument must be a string, or an array.') unless [String, Array, Fixnum].include? msisdns.class
        raise(InvalidFormatException, 'Invalid format passed as option.') unless ALLOWED_FORMATS.include? options[:format]
        raise(InvalidCountryCodeException, 'Invalid country code passed as option.') unless ALLOWED_CODES.keys.include? options[:country_code]

        msisdn_list =
            case msisdns
              when Array
                msisdns.collect {|msisdn| msisdn.to_s}
              when String
                [msisdns]
              when Fixnum
                [msisdns.to_s]
            end

        filtered_list = clean_and_filter(msisdn_list, options[:country_code])
        standardize(filtered_list, options[:format])
      end

      private

      def clean_and_filter(msisdn_list, country_code)
        filtered_list = msisdn_list.collect do |msisdn|
          cleaned_msisdn = msisdn.gsub(CLEANUP_REGEX, '')
          next unless cleaned_msisdn
          last_ten_digits = cleaned_msisdn.slice(-10..-1)
          next unless last_ten_digits
          prefix_code = cleaned_msisdn.slice(0..-11)
          (ALLOWED_CODES[country_code] << '').include?(prefix_code) ? last_ten_digits : nil
        end
        filtered_list.compact
      end

      def standardize(filtered_list, format)
        standardized_list = if format == 'international'
          filtered_list.collect { |msisdn| msisdn.msisdn(format: 'plus_country') }
        else
          filtered_list.collect { |msisdn| msisdn.msisdn(format: 'local') }
        end
        standardized_list.compact
      end

    end
  end
end