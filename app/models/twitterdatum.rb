class Twitterdatum < ActiveRecord::Base
  belongs_to :candidate

  def decode_data
    ActiveSupport::JSON.decode(ActiveSupport::Gzip.decompress(self.data))
  end

  def encode_data(data)
    ActiveSupport::Gzip.compress(ActiveSupport::JSON.encode(data))
  end
end
