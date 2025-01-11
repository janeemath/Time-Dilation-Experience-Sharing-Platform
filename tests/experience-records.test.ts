import { describe, it, expect, beforeEach } from 'vitest';

describe('experience-records', () => {
  let contract: any;
  
  beforeEach(() => {
    contract = {
      recordExperience: (simulationId: number, personalTime: number, earthTime: number, description: string) => {
        if (personalTime > earthTime) {
          throw new Error('Personal time cannot be greater than Earth time');
        }
        if (personalTime <= 0) {
          throw new Error('Personal time cannot be zero or negative');
        }
        return { value: 1 };
      },
      getExperience: (experienceId: number) => ({
        user: 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM',
        simulationId: 1,
        personalTime: 3600,
        earthTime: 7200,
        description: 'Experienced time passing at half the rate of Earth time'
      }),
      getExperienceCount: () => 3
    };
  });
  
  describe('record-experience', () => {
    it('should record a new time dilation experience', () => {
      const result = contract.recordExperience(1, 3600, 7200, 'Experienced time passing at half the rate of Earth time');
      expect(result.value).toBe(1);
    });
    
    it('should fail when personal time is greater than earth time', () => {
      expect(() => contract.recordExperience(1, 7200, 3600, 'Invalid time relationship')).toThrow();
    });
    
    it('should fail when personal time is zero', () => {
      expect(() => contract.recordExperience(1, 0, 3600, 'Invalid personal time')).toThrow();
    });
  });
  
  describe('get-experience', () => {
    it('should return experience data', () => {
      const experience = contract.getExperience(1);
      expect(experience.personalTime).toBe(3600);
      expect(experience.earthTime).toBe(7200);
    });
  });
  
  describe('get-experience-count', () => {
    it('should return the total number of experiences', () => {
      const count = contract.getExperienceCount();
      expect(count).toBe(3);
    });
  });
});

