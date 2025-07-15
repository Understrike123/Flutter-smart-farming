package models

type Schedule struct {
	ID              int    `json:"id"`
	ActuatorID      int    `json:"actuator_id"`
	ScheduleType    string `json:"schedule_type"`
	TimeOfDay       string `json:"time_of_day"`
	DurationMinutes int    `json:"duration_minutes"`
	IsActive        bool   `json:"is_active"`
}
