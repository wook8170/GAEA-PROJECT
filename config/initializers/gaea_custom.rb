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
      
      # 전역 설정 강제 주입
      Setting.ee_hide_banners = true
      Setting.ee_manager_visible = false
      
      # 엔터프라이즈 토큰 클래스 패치 (모든 기능 해제)
      class << EnterpriseToken
        def allows_to?(_feature)
          true
        end

        def active?
          true
        end

        def hide_banners?
          true
        end
      end

      # 기존 관리자 계정 언어 및 타임존 강제 변경
      admin = User.find_by(login: 'admin')
      if admin
        admin.update_columns(language: 'ko') if admin.language != 'ko'
        # time_zone 직접 변경은 UserPreference를 통해야 함
        pref = admin.pref
        if pref.time_zone != 'Seoul'
          pref.time_zone = 'Seoul'
          pref.save
        end
      end
    end
  rescue => e
    Rails.logger.error "GAEA-PROJECT 초기화 중 오류 발생: #{e.message}"
  end
end
