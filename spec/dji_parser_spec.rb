require 'spec_helper'

describe DjiParser do
  let(:data) { DjiParser.parse('data/DJIFlightRecord_2015-12-29_[19-05-48].txt') }

  it 'has a version number' do
    expect(DjiParser::VERSION).not_to be nil
  end

  context 'for the 1st point' do
    let(:point) { data.first }

    it 'parses longitude correctly' do
      expect(point.longitude).to eq(-1.7665183228942154)
    end

    it 'parses latitude correctly' do
      expect(point.latitude).to eq(53.73587938722398)
    end

    it 'parses height correctly' do
      expect(point.height).to be_zero
    end

    it 'parses x speed correctly' do
      expect(point.x_speed).to be_zero
    end

    it 'parses y speed correctly' do
      expect(point.y_speed).to be_zero
    end

    it 'parses z speed correctly' do
      expect(point.z_speed).to be_zero
    end

    it 'parses pitch correctly' do
      expect(point.pitch).to be_zero
    end

    it 'parses roll correctly' do
      expect(point.roll).to eq(-13)
    end

    it 'parses yaw correctly' do
      expect(point.yaw).to eq(637)
    end

    it 'returns true if in rc state' do
      expect(point.in_rc_state).to be_truthy
    end

    it 'parses fly state correctly' do
      expect(point.fly_state).to eq('GPS_ATTI')
    end

    it 'parses app commend correctly' do
      expect(point.app_commend).to eq(1)
    end

    it 'returns true if IOC works' do
      expect(point.can_ioc_work).to be_truthy
    end

    it 'returns 0 for grounded position correctly' do
      expect(point.ground_or_sky).to eq(0)
    end

    it 'returns true if motor is up' do
      expect(point.motor_up).to be_truthy
    end

    it 'returns true if swave work' do
      expect(point.swave_work).to be_truthy
    end

    it 'parses go home status correctly' do
      expect(point.go_home_status).to eq('STANDBY')
    end

    it 'return true if imu is preheated' do
      expect(point.imu_preheated).to be_truthy
    end

    it 'returns false if vision is not used' do
      expect(point.vision_used).to be_falsey
    end

    it 'parses voltage warning correctly' do
      expect(point.voltage_warning).to eq(0)
    end

    it 'parses mode channel correctly' do
      expect(point.mode_channel).to eq(2)
    end

    it 'returns false if there is no compass error' do
      expect(point.compass_error).to be_falsey
    end

    it 'returns false if there is no wave error' do
      expect(point.wave_error).to be_falsey
    end

    it 'parses gps level correctly' do
      expect(point.gps_level).to eq(5)
    end

    it 'parses battery type correctly' do
      expect(point.battery_type).to eq('SMART')
    end

    it 'returns false if accelerator is over range' do
      expect(point.accelerator_over_range).to be_falsey
    end

    it 'returns false if drone is not vibrating' do
      expect(point.vibrating).to be_falsey
    end

    it 'returns false if barometer is not dead in air' do
      expect(point.barometer_dead_in_air).to be_falsey
    end

    it 'returns false when force is enough' do
      expect(point.not_enough_force).to be_falsey
    end

    it 'parses gps num correctly' do
      expect(point.gps_num).to eq(15)
    end

    it 'parses flight action correctly' do
      expect(point.flight_action).to eq(14)
    end

    it 'parses motor failed cause correctly' do
      expect(point.motor_failed_cause).to eq('NONE')
    end

    it 'parses non gps cause correctly' do
      expect(point.non_gps_cause).to eq('ALREADY')
    end

    it 'parses battery correctly' do
      expect(point.battery).to eq(112)
    end

    it 'parses swave height correctly' do
      expect(point.swave_height).to eq(0)
    end

    it 'parses fly time correctly' do
      expect(point.fly_time).to eq(0)
    end

    it 'parses motor revolution correctly' do
      expect(point.motor_revolution).to eq(1)
    end

    it 'parses fly version correctly' do
      expect(point.fly_version).to eq(6)
    end

    it 'parses drone type correctly' do
      expect(point.drone_type).to eq('P3S')
    end

    it 'parses IMU init fail reason correctly' do
      expect(point.imu_init_fail_reason).to eq('MONITOR_ERROR')
    end

    it 'returns true if there is IMU init error' do
      expect(point.imu_init_error).to be_truthy
    end
  end

  context 'for the 100th point' do
    let(:point) { data[99] }

    it 'parses longitude correctly' do
      expect(point.longitude).to eq(-1.766620608256993)
    end

    it 'parses latitude correctly' do
      expect(point.latitude).to eq(53.73591894290776)
    end

    it 'parses height correctly' do
      expect(point.height).to eq(4.5)
    end

    it 'parses x speed correctly' do
      expect(point.x_speed).to eq(13)
    end

    it 'parses y speed correctly' do
      expect(point.y_speed).to eq(-20)
    end

    it 'parses z speed correctly' do
      expect(point.z_speed).to eq(-12)
    end

    it 'parses pitch correctly' do
      expect(point.pitch).to eq(-30)
    end

    it 'parses roll correctly' do
      expect(point.roll).to eq(107)
    end

    it 'parses yaw correctly' do
      expect(point.yaw).to eq(628)
    end

    it 'returns 2 on air position correctly' do
      expect(point.ground_or_sky).to eq(2)
    end

    it 'returns false unless swave work' do
      expect(point.swave_work).to be_falsey
    end

    it 'parses gps num correctly' do
      expect(point.gps_num).to eq(17)
    end

    it 'parses swave height correctly' do
      expect(point.swave_height).to eq(39)
    end

    it 'parses fly time correctly' do
      expect(point.fly_time).to eq(10.3)
    end
  end
end
