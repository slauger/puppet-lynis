# frozen_string_literal: true

require 'spec_helper'

describe 'lynis' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with default parameters' do
        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_class('lynis') }
        it { is_expected.to contain_class('lynis::package') }
        it { is_expected.to contain_class('lynis::config') }

        # Verify class ordering
        it { is_expected.to contain_class('lynis::package').that_comes_before('Class[lynis::config]') }

        # Package resource
        it { is_expected.to contain_package('lynis').with_ensure('present') }

        # Cron resource with defaults
        it {
          is_expected.to contain_cron('lynis').with(
            'ensure'  => 'present',
            'command' => '/usr/sbin/lynis audit system &> /dev/null',
            'user'    => 'root',
          )
        }

        # When cron_hour and cron_minute are not set (nil), fqdn_rand is used.
        # The exact values depend on the FQDN from the facts, so we verify
        # that hour is within the fqdn_rand(6) range and minute within fqdn_rand(59).
        it {
          cron_resource = catalogue.resource('Cron[lynis]')
          expect(cron_resource[:hour].to_i).to be >= 0
          expect(cron_resource[:hour].to_i).to be < 6
        }

        it {
          cron_resource = catalogue.resource('Cron[lynis]')
          expect(cron_resource[:minute].to_i).to be >= 0
          expect(cron_resource[:minute].to_i).to be < 59
        }
      end

      context 'with custom cron_hour and cron_minute' do
        let(:params) do
          {
            'cron_hour'   => '3',
            'cron_minute' => '45',
          }
        end

        it { is_expected.to compile.with_all_deps }

        it {
          is_expected.to contain_cron('lynis').with(
            'ensure'  => 'present',
            'command' => '/usr/sbin/lynis audit system &> /dev/null',
            'user'    => 'root',
            'hour'    => '3',
            'minute'  => '45',
          )
        }
      end

      context 'with cron_ensure set to absent' do
        let(:params) do
          {
            'cron_ensure' => 'absent',
          }
        end

        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_cron('lynis').with_ensure('absent') }
      end

      context 'with only cron_hour set' do
        let(:params) do
          {
            'cron_hour' => '5',
          }
        end

        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_cron('lynis').with_hour('5') }

        # minute should still use fqdn_rand
        it {
          cron_resource = catalogue.resource('Cron[lynis]')
          expect(cron_resource[:minute].to_i).to be >= 0
          expect(cron_resource[:minute].to_i).to be < 59
        }
      end

      context 'with only cron_minute set' do
        let(:params) do
          {
            'cron_minute' => '30',
          }
        end

        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_cron('lynis').with_minute('30') }

        # hour should still use fqdn_rand
        it {
          cron_resource = catalogue.resource('Cron[lynis]')
          expect(cron_resource[:hour].to_i).to be >= 0
          expect(cron_resource[:hour].to_i).to be < 6
        }
      end

      context 'with invalid cron_ensure' do
        let(:params) do
          {
            'cron_ensure' => 'invalid',
          }
        end

        it { is_expected.to compile.and_raise_error(%r{expects a match for Enum}) }
      end
    end
  end
end
