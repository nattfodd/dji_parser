require_relative 'binread_helpers'

module DjiParser
  class Osd
    include BinreadHelpers

    attr_reader :accelerator_over_range, :app_commend, :barometer_dead_in_air,
      :battery, :battery_type, :can_ioc_work, :compass_error, :drone_type,
      :flight_action, :fly_state, :fly_time, :fly_version, :go_home_status,
      :gps_level, :gps_num, :grounded, :height, :imu_init_error,
      :imu_init_fail_reason, :imu_preheated, :in_rc_state, :latitude,
      :longitude, :mode_channel, :motor_failed_cause, :motor_revolution,
      :motor_up, :non_gps_cause, :not_enough_force, :pitch, :roll,
      :swave_height, :swave_work, :vibrating, :vision_used, :voltage_warning,
      :wave_error, :x_speed, :y_speed, :yaw, :z_speed

    DRONE_TYPES = {
      '0' => 'Unknown',
      '1' => 'Inspire',
      '2' => 'P3S',
      '3' => 'P3X',
      '4' => 'P3C',
      '5' => 'OpenFrame',
      '100' => 'None'
    }

    FLY_STATE = {
      '0' => 'MANUAL',
      '1' => 'ATTI',
      '2' => 'ATTI_CL',
      '3' => 'ATTI_HOVER',
      '4' => 'HOVER',
      '6' => 'GPS_ATTI',
      '7' => 'GPS_CL',
      '8' => 'GPS_HOME_LOCK',
      '9' => 'GPS_HOT_POINT',
      '10' => 'ASSISTED_TAKEOFF',
      '11' => 'AUTO_TAKEOFF',
      '12' => 'AUTO_LANDING',
      '13' => 'ATTI_LANDING',
      '14' => 'NAVI_GO',
      '15' => 'GO_HOME',
      '16' => 'CLICK_GO',
      '17' => 'JOYSTICK',
      '23' => 'ATTI_LIMITED',
      '24' => 'GPS_ATTI_LIMITED',
      '100' => 'OTHER' 
    }

    GOHOME_STATUS = {
      '0' => 'STANDBY',
      '1' => 'PREASCENDING',
      '2' => 'ALIGN',
      '3' => 'ASCENDING',
      '4' => 'CRUISE',
      '7' => 'OTHER'
    }

    BATTERY_TYPE = {
      '0' => 'UNKNOWN',
      '1' => 'NONSMART',
      '2' => 'SMART'
    }

    MOTOR_START_FAILED_CAUSE = {
      '0' => 'None',
      '1' => 'CompassError',
      '2' => 'AssistantProtected',
      '3' => 'DeviceLocked',
      '4' => 'DistanceLimit',
      '5' => 'IMUNeedCalibration',
      '6' => 'IMUSNError',
      '7' => 'IMUWarning',
      '8' => 'CompassCalibrating',
      '9' => 'AttiError',
      '10' => 'NoviceProtected',
      '11' => 'BatteryCellError',
      '12' => 'BatteryCommuniteError',
      '13' => 'SeriouLowVoltage',
      '14' => 'SeriouLowPower',
      '15' => 'LowVoltage',
      '16' => 'TempureVolLow',
      '17' => 'SmartLowToLand',
      '18' => 'BatteryNotReady',
      '19' => 'SimulatorMode',
      '20' => 'PackMode',
      '21' => 'AttitudeAbNormal',
      '22' => 'UnActive',
      '23' => 'FlyForbiddenError',
      '24' => 'BiasError',
      '25' => 'EscError',
      '26' => 'ImuInitError',
      '27' => 'SystemUpgrade',
      '28' => 'SimulatorStarted',
      '29' => 'ImuingError',
      '30' => 'AttiAngleOver',
      '31' => 'GyroscopeError',
      '32' => 'AcceletorError',
      '33' => 'CompassFailed',
      '34' => 'BarometerError',
      '35' => 'BarometerNegative',
      '36' => 'CompassBig',
      '37' => 'GyroscopeBiasBig',
      '38' => 'AcceletorBiasBig',
      '39' => 'CompassNoiseBig',
      '40' => 'BarometerNoiseBig',
      '256' => 'OTHER'
    }

    NON_GPS_CAUSE  = {
      '0' => 'ALREADY',
      '1' => 'FORBIN',
      '2' => 'GPSNUM_NONENOUGH',
      '3' => 'GPS_HDOP_LARGE',
      '4' => 'GPS_POSITION_NONMATCH',
      '5' => 'SPEED_ERROR_LARGE',
      '6' => 'YAW_ERROR_LARGE',
      '7' => 'COMPASS_ERROR_LARGE',
      '8' => 'UNKNOWN'
    }

    IMU_INITFAIL_REASON = {
      '0' => 'MONITOR_ERROR',
      '1' => 'COLLECTING_DATA',
      '2' => 'GYRO_DEAD',
      '3' => 'ACCE_DEAD',
      '4' => 'COMPASS_DEAD',
      '5' => 'BAROMETER_DEAD',
      '6' => 'BAROMETER_NEGATIVE',
      '7' => 'COMPASS_MOD_TOO_LARGE',
      '8' => 'GYRO_BIAS_TOO_LARGE',
      '9' => 'ACCE_BIAS_TOO_LARGE',
      '10' => 'COMPASS_NOISE_TOO_LARGE',
      '11' => 'BAROMETER_NOISE_TOO_LARGE',
      '12' => 'WAITING_MC_STATIONARY',
      '13' => 'ACCE_MOVE_TOO_LARGE',
      '14' => 'MC_HEADER_MOVED',
      '15' => 'MC_VIBRATED',
      '16' => 'NONE'
    }

    def initialize(buffer, offset, dbg)
      @buffer, @block_offset = buffer, offset
      #puts dbg
      #debugger if dbg >= 99
    end

    def accelerator_over_range
      read_unsigned_int(32) >> 24 & 1 != 0
    end

    def app_commend
      read_unsigned_char(31)
    end

    def barometer_dead_in_air
      read_unsigned_int(32) >> 26 & 1 != 0
    end

    def battery
      read_unsigned_char(40)
    end

    def battery_type
      return BATTERY_TYPE['2'] unless drone_type == 'P3C'

      BATTERY_TYPE[(read_unsigned_int(32) >> 22 & 3).to_s]
    end

    def can_ioc_work
      (read_unsigned_int(32) & 1) == 1
    end

    def compass_error
      !(read_unsigned_int(32) & 65536).zero?
    end

    def drone_type
      DRONE_TYPES[read_unsigned_char(48).to_s]
    end

    def flight_action
      read_unsigned_char(37)
    end

    def fly_state
      FLY_STATE[(read_unsigned_char(30) & -129).to_s]
    end

    def fly_time
      read_unsigned_short(42).to_f / 10
    end

    def fly_version
      read_unsigned_char(47)
    end

    def go_home_status
      GOHOME_STATUS[(read_unsigned_int(32) >> 5 & 7).to_s]
    end

    def gps_level
      read_unsigned_int(32) >> 18 & 15
    end

    def gps_num
      read_unsigned_char(36)
    end

    def ground_or_sky
      read_unsigned_int(32) >> 1 & 3
    end

    def height
      read_signed_short(16).to_f / 10
    end

    def imu_init_error
      reason = imu_init_fail_reason
      reason != 'None' &&
        reason != 'ColletingData' &&
        reason != 'MonitorError'
    end

    def imu_init_fail_reason
      IMU_INITFAIL_REASON[read_unsigned_char(49).to_s]
    end

    def imu_preheated
      (read_unsigned_int(32) & 4096) != 0
    end

    def in_rc_state
      (read_unsigned_char(30) & 128).zero?
    end

    def longitude
      read_double(0) * 180 / Math::PI
    end

    def latitude
      read_double(8) * 180 / Math::PI
    end

    def mode_channel
      (read_unsigned_int(32) & 24576) >> 13
    end

    def motor_failed_cause
      s = read_unsigned_char(38)
      return 'NONE' if (s >> 7).zero?

      MOTOR_START_FAILED_CAUSE[(s & 127).to_s]
    end

    def motor_revolution
      read_unsigned_char(44)
    end

    def motor_up
      (read_unsigned_int(32) >> 3 & 1) == 1
    end

    def non_gps_cause
      NON_GPS_CAUSE[(read_unsigned_char(39) & 15).to_s]
    end

    def not_enough_force
      !(read_unsigned_int(32) >> 28 & 1).zero?
    end

    def pitch
      read_signed_short(24)
    end

    def roll
      read_signed_short(26)
    end

    def swave_height
      read_unsigned_char(41)
    end

    def swave_work
      !(read_unsigned_int(32) & 16).zero?
    end

    def vibrating
      !(read_unsigned_int(32) >> 25 & 1).zero?
    end

    def vision_used
      !(read_unsigned_int(32) & 256).zero?
    end

    def voltage_warning
      (read_unsigned_int(32) & 1536) >> 9
    end

    def wave_error
      !(read_unsigned_int(32) & 131072).zero?
    end

    def x_speed
      read_signed_short(18)
    end

    def y_speed
      read_signed_short(20)
    end

    def z_speed
      read_signed_short(22)
    end

    def yaw
      read_signed_short(28)
    end

  end
end
