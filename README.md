Sanitize MSISDNS as per mobile number format. This is specially useful for formating Android mobile numbers which are stored in different formats. Currently only Indian MSISDNs are supported.

##Usage

    gem install sanitized_msisdns

    require 'msisdn_sanitizer'

    MSISDN::Sanitizer.sanitize('00919876543210')
     => ["+919876543210"]

    MSISDN::Sanitizer.sanitize('0987-6543210')
     => ["+919876543210"]

    MSISDN::Sanitizer.sanitize(['00919876543210', '9037 123 456', '04972123465'])
     => ["+919876543210", "+919037123456"]

    MSISDN::Sanitizer.sanitize(9876543210)
     => ["+919876543210"]

You could also specify options, format & country_code ( Right now the only supported country code is ':in')
The defaults are
{
    :country_code => :in,
    :format => 'international'
}

    MSISDN::Sanitizer.sanitize(['00919876543210', '9037 123 456', '04972123465'], format: 'local')
     => ["9876543210", "9037123456"]




