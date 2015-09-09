require './app/data/extract/candidate_retweeted'
require './app/data/extract/find_top_words'
require './app/data/extract/followers_list_infos'
require './app/data/extract/tweets_list_infos'

namespace :datas do

  desc 'create data instances with twitterdata instances'
  task :seed => :environment do
    Candidate.all.each do |candidate|
      ExtractTweetsListInfos.new({
        screen_name: candidate.screen_name,
        data_type: 'retweets',
        at_least: 10
      }).run

      ExtractTweetsListInfos.new({
        screen_name: candidate.screen_name,
        data_type: 'favorites',
        at_least: 5
      }).run

      ExtractCandidateRetweeted.new({
        screen_name: candidate.screen_name,
        data_type: 'candidate retweets'
      }).run

      ExtractTweetsListInfos.new({
        screen_name: candidate.screen_name,
        data_type: 'RT retweets',
        at_least: 10
      }).run

      ExtractTweetsListInfos.new({
        screen_name: candidate.screen_name,
        data_type: 'RT favorites',
        at_least: 5
      }).run

      ExtractFollowersListInfo.new({
        screen_name: candidate.screen_name,
        data_type: 'followers followers',
        at_least: 1000
      }).run

      ExtractFollowersListInfo.new({
        screen_name: candidate.screen_name,
        data_type: 'followers listed',
        at_least: 20
      }).run

      ExtractFollowersListInfo.new({
        screen_name: candidate.screen_name,
        data_type: 'followers tweets',
        at_least: 2000
      }).run

      ExtractFollowersListInfo.new({
        screen_name: candidate.screen_name,
        data_type: 'followers followings',
        at_least: 50
      }).run

      ExtractTweetsListInfos.new({
        screen_name: candidate.screen_name,
        data_type: 'mentions',
        top_size: 20
      }).run

      ExtractTweetsListInfos.new({
        screen_name: candidate.screen_name,
        data_type: 'RT mentions',
        top_size: 20
      }).run

      FindTopWords.new({
        screen_name: candidate.screen_name,
        data_type: 'words',
        content_type: 'tweet',
        top_size: 20
      }).run

      ExtractTweetsListInfos.new({
        screen_name: candidate.screen_name,
        data_type: 'hashtags',
        top_size: 20
      }).run

      # ExtractTweetsListInfos.new({
      #   screen_name: candidate.screen_name,
      #   data_type: 'RT hashtags',
      #   top_size: 20
      # }).run

      ExtractCandidateRetweeted.new({
        screen_name: candidate.screen_name,
        data_type: 'candidate retweeted',
        content_type: 'screen_name',
        top_size: 20
      }).run

      FindTopWords.new({
        screen_name: candidate.screen_name,
        data_type: 'followers bios',
        content_type: 'follower',
        top_size: 20
      }).run
    end
  end

  desc 'update data instances with twitterdata instances'
  task :update => :environment do
    Candidate.all.each do |candidate|
      ExtractTweetsListInfos.new({
        screen_name: candidate.screen_name,
        data_type: 'retweets',
        at_least: 10
      }).update

      ExtractTweetsListInfos.new({
        screen_name: candidate.screen_name,
        data_type: 'favorites',
        at_least: 5
      }).update

      ExtractCandidateRetweeted.new({
        screen_name: candidate.screen_name,
        data_type: 'candidate retweets'
      }).update

      ExtractTweetsListInfos.new({
        screen_name: candidate.screen_name,
        data_type: 'RT retweets',
        at_least: 10
      }).update

      ExtractTweetsListInfos.new({
        screen_name: candidate.screen_name,
        data_type: 'RT favorites',
        at_least: 5
      }).update

      ExtractFollowersListInfo.new({
        screen_name: candidate.screen_name,
        data_type: 'followers followers',
        at_least: 1000
      }).update

      ExtractFollowersListInfo.new({
        screen_name: candidate.screen_name,
        data_type: 'followers listed',
        at_least: 20
      }).update

      ExtractFollowersListInfo.new({
        screen_name: candidate.screen_name,
        data_type: 'followers tweets',
        at_least: 2000
      }).update

      ExtractFollowersListInfo.new({
        screen_name: candidate.screen_name,
        data_type: 'followers followings',
        at_least: 50
      }).update

      ExtractTweetsListInfos.new({
        screen_name: candidate.screen_name,
        data_type: 'mentions',
        top_size: 20
      }).update

      ExtractTweetsListInfos.new({
        screen_name: candidate.screen_name,
        data_type: 'RT mentions',
        top_size: 20
      }).update

      FindTopWords.new({
        screen_name: candidate.screen_name,
        data_type: 'words',
        content_type: 'tweet',
        top_size: 20
      }).update

      ExtractTweetsListInfos.new({
        screen_name: candidate.screen_name,
        data_type: 'hashtags',
        top_size: 20
      }).update

      # ExtractTweetsListInfos.new({
      #   screen_name: candidate.screen_name,
      #   data_type: 'RT hashtags',
      #   top_size: 20
      # }).update

      ExtractCandidateRetweeted.new({
        screen_name: candidate.screen_name,
        data_type: 'candidate retweeted',
        content_type: 'screen_name',
        top_size: 20
      }).update

      FindTopWords.new({
        screen_name: candidate.screen_name,
        data_type: 'followers bios',
        content_type: 'follower',
        top_size: 20
      }).update
    end
  end
end

