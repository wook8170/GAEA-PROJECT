# frozen_string_literal: true

# GAEA-PROJECT 커스터마이징 초기화 설정
Rails.application.config.after_initialize do
  begin
    # 기본 언어를 한국어로 설정
    if Setting.table_exists?
      Setting.default_language = 'ko' if Setting.default_language != 'ko'
      Setting.user_default_timezone = 'Seoul' if Setting.user_default_timezone != 'Seoul'
      
      # 개발 환경 하이라이트 비활성화
      Setting.development_highlight_enabled = false
      
      # 엔터프라이즈 배너 숨기기 및 관리 페이지 비활성화
      Setting.ee_hide_banners = true
      Setting.ee_manager_visible = false
    end
  rescue => e
    Rails.logger.error "GAEA-PROJECT 초기화 중 오류 발생: #{e.message}"
  end
end
