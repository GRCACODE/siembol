import { Component, OnInit } from '@angular/core';
import { ChangeDetectionStrategy } from '@angular/core';
import { AppConfigService } from '@app/config/app-config.service';
import { Observable } from 'rxjs';
import { MatDialog } from '@angular/material/dialog';
import { BuildInfoDialogComponent } from '../build-info-dialog/build-info-dialog.component';
import { EditorService } from '../../services/editor.service';
import { AppService } from '../../services/app.service';
import { Router } from '@angular/router';
import { UserRole } from '@app/model/config-model';

@Component({
    changeDetection: ChangeDetectionStrategy.OnPush,
    selector: 're-nav-bar',
    styleUrls: ['./nav-bar.component.scss'],
    templateUrl: './nav-bar.component.html',
})
export class NavBarComponent implements OnInit {
    user: String;
    userRoles: string[];
    loading$: Observable<boolean>;
    serviceName$: Observable<string>;
    serviceName: string;
    serviceNames: string[];
    environment: string;
    isAdminChecked: boolean;
    private readonly ADMIN_PATH = "/admin";

    constructor(private config: AppConfigService, 
        private appService: AppService, 
        private editorService: EditorService, 
        private dialog: MatDialog, private router: Router) {
        this.user = this.appService.user;
        this.serviceName$ = this.editorService.serviceName$;
        this.serviceNames = this.appService.serviceNames;
        this.environment = this.config.environment;
        this.isAdminChecked = this.editorService.adminMode;
    }

    ngOnInit() {
        this.serviceName$.subscribe(service => {
            this.userRoles = this.appService.getUserServiceRoles(service);
            this.serviceName = service;
        })
    }

    public showAboutApp() {
        this.dialog.open(BuildInfoDialogComponent, { data: this.config.buildInfo }).afterClosed().subscribe();
    }

    public onToggleAdmin() {
        let path = this.isAdminChecked ? this.ADMIN_PATH : "";
        this.router.navigate([this.serviceName + path]);
    }

    public getPath(service: string): string {
        let path = service;
        const roles = this.appService.getUserServiceRoles(service);
        let hasMultipleUserRoles = roles.length > 1;
        if ((hasMultipleUserRoles && this.isAdminChecked) || (!hasMultipleUserRoles && roles.includes(UserRole.SERVICE_ADMIN))) {
            path += this.ADMIN_PATH;
        }
        return path;  
    }
}
