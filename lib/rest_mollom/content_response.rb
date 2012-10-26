#
# original code from https://github.com/openminds/ruby-mollom
#

module RestMollom
  class ContentResponse
    attr_reader :content_id
    
    # An assessment of the content's quality, between 0 and 1; 0 being very low, 1 being high quality if specified in check_content checks
    attr_reader :quality
    
    # An assessment of the content's profanity level, between 0 and 1; 0 being non-profane, 1 being very profane if specified in check_content checks
    attr_reader :profanity
    
    # An assessment of the content's sentiment, between 0 and 1; 0 being a very negative sentiment, 1 being a very positive sentiment if specified in check_content checks
    attr_reader :sentiment
    
    # a list of structs containing pairs of language and confidence values if specified in checkContent checks
    attr_reader :language

    Ham     = 'ham'
    Spam    = 'spam'
    Unsure  = 'unsure'

    # This class should only be initialized from within the +check_content+ command.
    def initialize(hash)
      @hash = hash
      @classification = hash["content"]["spamClassification"]
      @content_id     = hash["content"]["id"]
      @quality        = hash["content"]["qualityScore"]
      @profanity      = hash["content"]["profanityScore"]
      @sentiment      = hash["content"]["sentimentScore"]
      #@language      = hash["content"]["languages"]
    end
    
    # Is the content Spam?
    def spam?
      @classification == Spam
    end

    # Is the content Ham?
    def ham?
      @classification == Ham
    end

    # is Mollom unsure about the content?
    def unsure?
      @classification == Unsure
    end

    # Returns 'unknown', 'ham', 'unsure' or 'spam', depending on what the content is.
    def to_s
      @classification
    end
    
    # Returns the original hash for testing
    def to_hash
      @hash
    end
  end
end
