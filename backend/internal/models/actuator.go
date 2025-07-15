package models

type Actuator struct {
	ID     int    `json:"id"`
	Name   string `json:"name"`
	Type   string `json:"type"`
	Status bool   `json:"status"` // false: OFF, true: ON
	Mode   string `json:"mode"`   // "auto" atau "manual"
}